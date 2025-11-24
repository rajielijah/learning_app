import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_learning_app/core/config/category_config.dart';
import 'package:quiz_learning_app/core/models/quiz_category.dart';
import 'package:quiz_learning_app/core/models/quiz_result.dart';
import 'package:quiz_learning_app/core/models/user_profile.dart';
import 'package:quiz_learning_app/core/network/connectivity_service.dart';
import 'package:quiz_learning_app/core/session/session_cubit.dart';
import 'package:quiz_learning_app/features/profile/repositories/user_repository.dart';
import 'package:quiz_learning_app/features/quiz/repositories/quiz_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required UserRepository userRepository,
    required QuizRepository quizRepository,
    required ConnectivityService connectivityService,
    required SessionCubit sessionCubit,
  })  : _userRepository = userRepository,
        _quizRepository = quizRepository,
        _connectivityService = connectivityService,
        _sessionCubit = sessionCubit,
        super(HomeState.initial()) {
    on<HomeStarted>(_onStarted);
    on<HomeProgressUpdated>(_onProgressUpdated);
    on<HomeConnectivityChanged>(_onConnectivityChanged);
    on<HomeSyncRequested>(_onSyncRequested);
    on<HomeProfileStreamed>(_onProfileStreamed);

    _sessionSubscription = _sessionCubit.stream.listen((_) {
      add(const HomeStarted());
    });

    _userSubscription = _userRepository.changes.listen((profile) {
      add(HomeProfileStreamed(profile));
    });

    _connectivitySubscription = _connectivityService.onStatusChange.listen((isOnline) {
      add(HomeConnectivityChanged(isOnline));
    });
  }

  final UserRepository _userRepository;
  final QuizRepository _quizRepository;
  final ConnectivityService _connectivityService;
  final SessionCubit _sessionCubit;

  StreamSubscription? _sessionSubscription;
  StreamSubscription? _userSubscription;
  StreamSubscription? _connectivitySubscription;

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) async {
    final session = _sessionCubit.state.session;
    if (session == null) {
      emit(HomeState.initial());
      return;
    }

    emit(state.copyWith(loading: true, error: null));

    final profile = _userRepository.upsertFromSession(session);
    final results = _quizRepository.loadCachedResults();
    final progress = _mapResults(results);

    final isOnline = await _connectivityService.isConnected;

    emit(
      state.copyWith(
        loading: false,
        profile: profile,
        hasSession: true,
        progress: progress,
        isOffline: !isOnline,
      ),
    );
  }

  Future<void> _onProgressUpdated(
    HomeProgressUpdated event,
    Emitter<HomeState> emit,
  ) async {
    final updated = Map<String, QuizResult>.from(state.progress)
      ..[event.result.categoryId] = event.result;
    emit(state.copyWith(progress: updated));
  }

  void _onConnectivityChanged(
    HomeConnectivityChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(isOffline: !event.isOnline));
    if (event.isOnline) add(const HomeSyncRequested());
  }

  Future<void> _onSyncRequested(
    HomeSyncRequested event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true));
    await _quizRepository.syncPendingResults();
    emit(state.copyWith(isSyncing: false));
  }

  void _onProfileStreamed(
    HomeProfileStreamed event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(profile: event.profile, hasSession: true));
  }

  Map<String, QuizResult> _mapResults(List<QuizResult> results) {
    final map = <String, QuizResult>{};
    for (final result in results) {
      map[result.categoryId] = result;
    }
    return map;
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    _userSubscription?.cancel();
    _connectivitySubscription?.cancel();
    return super.close();
  }
}

