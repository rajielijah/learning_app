import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_learning_app/core/models/session.dart';
import 'package:quiz_learning_app/core/session/session_repository.dart';

class SessionState extends Equatable {
  const SessionState({this.session});

  final Session? session;

  bool get isAuthenticated => session != null;

  SessionState copyWith({Session? session}) {
    return SessionState(session: session ?? this.session);
  }

  @override
  List<Object?> get props => [session];
}

class SessionCubit extends Cubit<SessionState> {
  SessionCubit(this._repository) : super(SessionState(session: _repository.read()));

  final SessionRepository _repository;

  Future<void> setSession(Session session) async {
    await _repository.save(session);
    emit(SessionState(session: session));
  }

  Future<void> clearSession() async {
    await _repository.clear();
    emit(const SessionState());
  }
}
