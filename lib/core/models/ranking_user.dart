import 'package:equatable/equatable.dart';

class RankingUser extends Equatable {
  const RankingUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.rank,
    required this.score,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final int rank;
  final int score;

  RankingUser copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    int? rank,
    int? score,
  }) {
    return RankingUser(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rank: rank ?? this.rank,
      score: score ?? this.score,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatarUrl': avatarUrl,
        'rank': rank,
        'score': score,
      };

  factory RankingUser.fromJson(Map<String, dynamic> json) {
    return RankingUser(
      id: json['id'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String,
      rank: json['rank'] as int,
      score: json['score'] as int,
    );
  }

  @override
  List<Object?> get props => [id, name, avatarUrl, rank, score];
}

