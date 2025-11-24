import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_learning_app/core/errors/app_exception.dart';
import 'package:quiz_learning_app/core/session/session_cubit.dart';
import 'package:quiz_learning_app/features/auth/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
    required SessionCubit sessionCubit,
  })  : _authRepository = authRepository,
        _sessionCubit = sessionCubit,
        super(const AuthState()) {
    on<AuthSubmitted>(_onSubmitted);
    on<AuthLogoutRequested>(_onLogoutRequested);
  }

  final AuthRepository _authRepository;
  final SessionCubit _sessionCubit;

  Future<void> _onSubmitted(AuthSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, error: null));
    try {
      final session =
          await _authRepository.login(email: event.email, password: event.password);
      await _sessionCubit.setSession(session);
      emit(state.copyWith(status: AuthStatus.success));
    } on AppException catch (error) {
      emit(state.copyWith(status: AuthStatus.failure, error: error.message));
    }
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _sessionCubit.clearSession();
    emit(const AuthState(status: AuthStatus.initial));
  }
}

