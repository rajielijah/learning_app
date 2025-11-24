import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_learning_app/core/models/quiz_question.dart';
import 'package:quiz_learning_app/core/models/quiz_result.dart';

class LocalCacheService {
  static const _questionsBoxName = 'quiz_questions';
  static const _resultsBoxName = 'quiz_results';

  late final Box _questionsBox;
  late final Box _resultsBox;

  Future<void> init() async {
    _questionsBox = await Hive.openBox(_questionsBoxName);
    _resultsBox = await Hive.openBox(_resultsBoxName);
  }

  Future<void> cacheQuestions(String categoryId, List<QuizQuestion> questions) async {
    final payload = questions.map((question) => question.toJson()).toList();
    await _questionsBox.put(categoryId, payload);
  }

  List<QuizQuestion>? readCachedQuestions(String categoryId) {
    final content = _questionsBox.get(categoryId);
    if (content is! List) return null;
    return content
        .map(
          (json) => QuizQuestion.fromJson(
            Map<String, dynamic>.from(json as Map<dynamic, dynamic>),
          ),
        )
        .toList();
  }

  Future<void> cacheResult(QuizResult result) async {
    final key = result.completedAt.toIso8601String();
    await _resultsBox.put(key, result.toJson());
  }

  List<QuizResult> pendingResults() {
    return _resultsBox.values
        .map(
          (json) => QuizResult.fromJson(
            Map<String, dynamic>.from(json as Map<dynamic, dynamic>),
          ),
        )
        .where((result) => !result.synced)
        .toList();
  }

  List<QuizResult> allResults() {
    return _resultsBox.values
        .map(
          (json) => QuizResult.fromJson(
            Map<String, dynamic>.from(json as Map<dynamic, dynamic>),
          ),
        )
        .toList();
  }

  Future<void> markResultSynced(QuizResult result) async {
    dynamic matchKey;
    for (final key in _resultsBox.keys) {
      final stored = _resultsBox.get(key);
      if (stored is! Map) continue;
      if (stored['completedAt'] == result.completedAt.toIso8601String()) {
        matchKey = key;
        break;
      }
    }
    if (matchKey == null) return;
    await _resultsBox.put(matchKey, result.copyWith(synced: true).toJson());
  }
}

