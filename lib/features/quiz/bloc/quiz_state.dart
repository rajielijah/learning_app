part of 'quiz_bloc.dart';

enum QuizStatus { initial, loading, countdown, question, evaluating, completed, failure }

class QuizState extends Equatable {
  const QuizState({
    this.status = QuizStatus.initial,
    this.questions = const [],
    this.currentIndex = 0,
    this.remainingSeconds = 60,
    this.countdownValue = 3,
    this.selectedAnswer,
    this.lastAnswerCorrect,
    this.correctCount = 0,
    this.error,
    this.categoryId,
    this.latestResult,
    this.isOffline = false,
  });

  final QuizStatus status;
  final List<QuizQuestion> questions;
  final int currentIndex;
  final int remainingSeconds;
  final int countdownValue;
  final String? selectedAnswer;
  final bool? lastAnswerCorrect;
  final int correctCount;
  final String? error;
  final String? categoryId;
  final QuizResult? latestResult;
  final bool isOffline;

  QuizState copyWith({
    QuizStatus? status,
    List<QuizQuestion>? questions,
    int? currentIndex,
    int? remainingSeconds,
    int? countdownValue,
    String? selectedAnswer,
    bool? lastAnswerCorrect,
    int? correctCount,
    String? error,
    String? categoryId,
    QuizResult? latestResult,
    bool? isOffline,
  }) {
    return QuizState(
      status: status ?? this.status,
      questions: questions ?? this.questions,
      currentIndex: currentIndex ?? this.currentIndex,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      countdownValue: countdownValue ?? this.countdownValue,
      selectedAnswer: selectedAnswer,
      lastAnswerCorrect: lastAnswerCorrect,
      correctCount: correctCount ?? this.correctCount,
      error: error,
      categoryId: categoryId ?? this.categoryId,
      latestResult: latestResult ?? this.latestResult,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  @override
  List<Object?> get props => [
        status,
        questions,
        currentIndex,
        remainingSeconds,
        countdownValue,
        selectedAnswer,
        lastAnswerCorrect,
        correctCount,
        error,
        categoryId,
        latestResult,
        isOffline,
      ];
}

