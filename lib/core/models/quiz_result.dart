import 'package:equatable/equatable.dart';

class QuizResult extends Equatable {
  const QuizResult({
    required this.categoryId,
    required this.correct,
    required this.total,
    required this.completedAt,
    this.synced = false,
  });

  final String categoryId;
  final int correct;
  final int total;
  final DateTime completedAt;
  final bool synced;

  QuizResult copyWith({
    String? categoryId,
    int? correct,
    int? total,
    DateTime? completedAt,
    bool? synced,
  }) {
    return QuizResult(
      categoryId: categoryId ?? this.categoryId,
      correct: correct ?? this.correct,
      total: total ?? this.total,
      completedAt: completedAt ?? this.completedAt,
      synced: synced ?? this.synced,
    );
  }

  Map<String, dynamic> toJson() => {
        'categoryId': categoryId,
        'correct': correct,
        'total': total,
        'completedAt': completedAt.toIso8601String(),
        'synced': synced,
      };

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      categoryId: json['categoryId'] as String,
      correct: json['correct'] as int,
      total: json['total'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
      synced: json['synced'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [categoryId, correct, total, completedAt, synced];
}

