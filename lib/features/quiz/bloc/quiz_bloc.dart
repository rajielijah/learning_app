import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_learning_app/core/models/quiz_question.dart';
import 'package:quiz_learning_app/core/models/quiz_result.dart';
import 'package:quiz_learning_app/core/network/connectivity_service.dart';
import 'package:quiz_learning_app/features/profile/repositories/user_repository.dart';
import 'package:quiz_learning_app/features/quiz/repositories/quiz_repository.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({
    required QuizRepository quizRepository,
    required UserRepository userRepository,
    required ConnectivityService connectivityService,
  })  : _quizRepository = quizRepository,
        _userRepository = userRepository,
        _connectivityService = connectivityService,
        super(const QuizState()) {
    on<QuizRequested>(_onRequested);
    on<QuizCountdownTicked>(_onCountdownTicked);
    on<QuizCountdownCompleted>(_onCountdownCompleted);
    on<QuizTimerTicked>(_onTimerTicked);
    on<QuizAnswerSelected>(_onAnswerSelected);
    on<QuizAdvanceRequested>(_onAdvanceRequested);
    on<QuizCleared>(_onCleared);
    on<QuizConnectivityChanged>(_onConnectivityChanged);

    _connectivitySubscription = _connectivityService.onStatusChange.listen((isOnline) {
      add(QuizConnectivityChanged(isOnline));
    });
  }

  final QuizRepository _quizRepository;
  final UserRepository _userRepository;
  final ConnectivityService _connectivityService;

  Timer? _countdownTimer;
  Timer? _questionTimer;
  StreamSubscription<bool>? _connectivitySubscription;

  Future<void> _onRequested(QuizRequested event, Emitter<QuizState> emit) async {
    emit(state.copyWith(status: QuizStatus.loading, categoryId: event.categoryId, error: null));
    final isOnline = await _connectivityService.isConnected;
    try {
      final questions = await _quizRepository.loadQuestions(event.categoryId);
      emit(state.copyWith(
        status: QuizStatus.countdown,
        questions: questions,
        countdownValue: 3,
        currentIndex: 0,
        correctCount: 0,
        selectedAnswer: null,
        lastAnswerCorrect: null,
        isOffline: !isOnline,
      ));
      _startCountdown();
    } catch (error) {
      emit(state.copyWith(status: QuizStatus.failure, error: error.toString()));
    }
  }

  void _onCountdownTicked(QuizCountdownTicked event, Emitter<QuizState> emit) {
    emit(state.copyWith(countdownValue: event.value));
  }

  void _onCountdownCompleted(QuizCountdownCompleted event, Emitter<QuizState> emit) {
    _startQuestionTimer(emit);
  }

  void _onTimerTicked(QuizTimerTicked event, Emitter<QuizState> emit) {
    if (event.remaining <= 0) {
      _questionTimer?.cancel();
      _evaluateAnswer(null, emit);
    } else {
      emit(state.copyWith(remainingSeconds: event.remaining));
    }
  }

  void _onAnswerSelected(QuizAnswerSelected event, Emitter<QuizState> emit) {
    if (state.status != QuizStatus.question) return;
    _questionTimer?.cancel();
    _evaluateAnswer(event.answer, emit);
  }

  Future<void> _onAdvanceRequested(
    QuizAdvanceRequested event,
    Emitter<QuizState> emit,
  ) async {
    if (state.currentIndex + 1 >= state.questions.length) {
      final result = QuizResult(
        categoryId: state.categoryId!,
        correct: state.correctCount,
        total: state.questions.length,
        completedAt: DateTime.now(),
      );
      await _quizRepository.saveResult(result);
      await _userRepository.updateScore(delta: result.correct * 10);
      emit(state.copyWith(status: QuizStatus.completed, latestResult: result));
      return;
    }
    emit(state.copyWith(
      currentIndex: state.currentIndex + 1,
      selectedAnswer: null,
      lastAnswerCorrect: null,
    ));
    _startQuestionTimer(emit);
  }

  void _onCleared(QuizCleared event, Emitter<QuizState> emit) {
    _cancelTimers();
    emit(const QuizState());
  }

  void _onConnectivityChanged(QuizConnectivityChanged event, Emitter<QuizState> emit) {
    emit(state.copyWith(isOffline: !event.isOnline));
  }

  void _evaluateAnswer(String? answer, Emitter<QuizState> emit) {
    final question = state.questions[state.currentIndex];
    final isCorrect = answer != null && answer == question.correctAnswer;
    final updatedCorrect = state.correctCount + (isCorrect ? 1 : 0);
    emit(
      state.copyWith(
        status: QuizStatus.evaluating,
        selectedAnswer: answer,
        lastAnswerCorrect: answer == null ? null : isCorrect,
        correctCount: updatedCorrect,
        remainingSeconds: 0,
      ),
    );
    Future<void>.delayed(const Duration(seconds: 1), () {
      if (!isClosed) add(const QuizAdvanceRequested());
    });
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    var value = 3;
    add(QuizCountdownTicked(value));
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      value -= 1;
      if (value <= 0) {
        timer.cancel();
        add(const QuizCountdownCompleted());
      } else {
        add(QuizCountdownTicked(value));
      }
    });
  }

  void _startQuestionTimer(Emitter<QuizState> emit) {
    _questionTimer?.cancel();
    var remaining = 60;
    emit(
      state.copyWith(
        status: QuizStatus.question,
        remainingSeconds: remaining,
        selectedAnswer: null,
        lastAnswerCorrect: null,
      ),
    );
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining -= 1;
      add(QuizTimerTicked(remaining));
    });
  }

  void _cancelTimers() {
    _countdownTimer?.cancel();
    _questionTimer?.cancel();
  }

  @override
  Future<void> close() {
    _cancelTimers();
    _connectivitySubscription?.cancel();
    return super.close();
  }
}

