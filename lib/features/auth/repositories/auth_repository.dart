import 'package:quiz_learning_app/core/errors/app_exception.dart';
import 'package:quiz_learning_app/core/models/session.dart';

class AuthRepository {
  Future<Session> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (email == 'test@gmail.com' && password == 'Test@123') {
      return Session(
        userId: 'demo-user',
        email: email,
        displayName: 'Quiz Master',
        avatarUrl: 'https://avatars.githubusercontent.com/u/14101776?v=4',
      );
    }
    throw AppException('Invalid email, please try again');
  }
}

