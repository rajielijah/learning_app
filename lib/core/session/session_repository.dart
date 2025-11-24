import 'package:quiz_learning_app/core/models/session.dart';

/// Simple in-memory session repository 
class SessionRepository {
  Session? _active;

  Session? read() => _active;

  Future<void> save(Session session) async {
    _active = session;
  }

  Future<void> clear() async {
    _active = null;
  }
}
