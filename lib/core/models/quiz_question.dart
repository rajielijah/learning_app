import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:html_unescape/html_unescape.dart';

final _unescape = HtmlUnescape();
final _random = Random();

class QuizQuestion extends Equatable {
  const QuizQuestion({
    required this.id,
    required this.categoryId,
    required this.category,
    required this.type,
    required this.difficulty,
    required this.question,
    required this.correctAnswer,
    required this.choices,
  });

  final String id;
  final String categoryId;
  final String category;
  final String type;
  final String difficulty;
  final String question;
  final String correctAnswer;
  final List<String> choices;

  factory QuizQuestion.fromApi({
    required Map<String, dynamic> json,
    required String categoryId,
  }) {
    final correct = _decode(json['correct_answer'] as String);
    final incorrect = (json['incorrect_answers'] as List<dynamic>)
        .map((value) => _decode(value as String))
        .toList();
    final answers = [...incorrect, correct]..shuffle(_random);
    return QuizQuestion(
      id: _generateId(categoryId, json['question'] as String),
      categoryId: categoryId,
      category: _decode(json['category'] as String),
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      question: _decode(json['question'] as String),
      correctAnswer: correct,
      choices: answers,
    );
  }

  QuizQuestion copyWith({
    String? id,
    String? categoryId,
    String? category,
    String? type,
    String? difficulty,
    String? question,
    String? correctAnswer,
    List<String>? choices,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      type: type ?? this.type,
      difficulty: difficulty ?? this.difficulty,
      question: question ?? this.question,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      choices: choices ?? this.choices,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'category': category,
        'type': type,
        'difficulty': difficulty,
        'question': question,
        'correctAnswer': correctAnswer,
        'choices': choices,
      };

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      category: json['category'] as String,
      type: json['type'] as String,
      difficulty: json['difficulty'] as String,
      question: json['question'] as String,
      correctAnswer: json['correctAnswer'] as String,
      choices: List<String>.from(json['choices'] as List<dynamic>),
    );
  }

  static String _decode(String value) => _unescape.convert(value);

  static String _generateId(String categoryId, String question) =>
      '$categoryId-${question.hashCode}';

  @override
  List<Object?> get props => [
        id,
        categoryId,
        category,
        type,
        difficulty,
        question,
        correctAnswer,
        choices,
      ];
}

