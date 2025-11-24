import 'package:equatable/equatable.dart';

class Session extends Equatable {
  const Session({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.avatarUrl,
  });

  final String userId;
  final String email;
  final String displayName;
  final String avatarUrl;

  Session copyWith({
    String? userId,
    String? email,
    String? displayName,
    String? avatarUrl,
  }) {
    return Session(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  @override
  List<Object?> get props => [userId, email, displayName, avatarUrl];
}
