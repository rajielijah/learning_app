import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_learning_app/core/models/user_profile.dart';
import 'package:quiz_learning_app/core/session/session_cubit.dart';
import 'package:quiz_learning_app/features/profile/repositories/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    required UserRepository userRepository,
    required SessionCubit sessionCubit,
  })  : _userRepository = userRepository,
        _sessionCubit = sessionCubit,
        super(const ProfileState()) {
    on<ProfileStarted>(_onStarted);
    on<ProfileUserChanged>(_onUserChanged);
    on<ProfileLogoutRequested>(_onLogoutRequested);

    _subscription = _userRepository.changes.listen((profile) {
      add(ProfileUserChanged(profile));
    });
  }

  final UserRepository _userRepository;
  final SessionCubit _sessionCubit;
  StreamSubscription<UserProfile>? _subscription;

  void _onStarted(ProfileStarted event, Emitter<ProfileState> emit) {
    emit(state.copyWith(profile: _userRepository.profile));
  }

  void _onUserChanged(ProfileUserChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(profile: event.profile));
  }

  Future<void> _onLogoutRequested(
    ProfileLogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    await _userRepository.clear();
    await _sessionCubit.clearSession();
    emit(const ProfileState());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

