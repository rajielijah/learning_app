import 'dart:async';

import 'package:quiz_learning_app/core/models/session.dart';
import 'package:quiz_learning_app/core/models/user_profile.dart';

class UserRepository {
  final _controller = StreamController<UserProfile>.broadcast();
  UserProfile? _profile;

  Stream<UserProfile> get changes => _controller.stream;

  UserProfile upsertFromSession(Session session) {
    _profile ??= UserProfile(
      id: session.userId,
      name: session.displayName,
      email: session.email,
      avatarUrl: session.avatarUrl,
      rank: 128,
      score: 1200,
    );
    _controller.add(_profile!);
    return _profile!;
  }

  UserProfile? get profile => _profile;

  Future<UserProfile> updateScore({
    required int delta,
    int? newRank,
  }) async {
    final current = _profile;
    if (current == null) {
      throw StateError('User profile not initialized');
    }
    _profile = current.copyWith(
      score: current.score + delta,
      rank: newRank ?? current.rank,
    );
    _controller.add(_profile!);
    return _profile!;
  }

  Future<void> clear() async {
    _profile = null;
  }

  void dispose() {
    _controller.close();
  }
}

