import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.rank,
    required this.score,
  });

  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final int rank;
  final int score;

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    int? rank,
    int? score,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rank: rank ?? this.rank,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatarUrl': avatarUrl,
        'rank': rank,
        'score': score,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String,
      rank: json['rank'] as int,
      score: json['score'] as int,
    );
  }

  @override
  List<Object?> get props => [id, name, email, avatarUrl, rank, score];
}

