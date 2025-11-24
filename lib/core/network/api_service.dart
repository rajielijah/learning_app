import 'package:dio/dio.dart';
import 'package:quiz_learning_app/core/errors/app_exception.dart';
import 'package:quiz_learning_app/core/models/quiz_question.dart';

class ApiService {
  ApiService({Dio? client}) : _client = client ?? Dio();

  final Dio _client;
  static const _baseUrl = 'https://opentdb.com/api.php';

  Future<List<QuizQuestion>> fetchQuestions({
    required String categoryId,
    int amount = 10,
    String difficulty = 'easy',
    String type = 'multiple',
  }) async {
    try {
      final response = await _client.get<Map<String, dynamic>>(
        _baseUrl,
        queryParameters: {
          'amount': amount,
          'category': categoryId,
          'difficulty': difficulty,
          'type': type,
        },
      );
      final results = response.data?['results'] as List<dynamic>? ?? [];
      if (results.isEmpty) {
        throw AppException('No questions available for category $categoryId');
      }
      return results
          .map((json) =>
              QuizQuestion.fromApi(json: json as Map<String, dynamic>, categoryId: categoryId))
          .toList();
    } on DioException catch (error) {
      throw AppException(error.message ?? 'Failed to fetch questions');
    }
  }
}

