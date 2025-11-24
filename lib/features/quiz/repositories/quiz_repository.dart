import 'dart:async';

import 'package:quiz_learning_app/core/errors/app_exception.dart';
import 'package:quiz_learning_app/core/models/quiz_question.dart';
import 'package:quiz_learning_app/core/models/quiz_result.dart';
import 'package:quiz_learning_app/core/network/api_service.dart';
import 'package:quiz_learning_app/core/network/connectivity_service.dart';
import 'package:quiz_learning_app/core/storage/local_cache_service.dart';

class QuizRepository {
  QuizRepository({
    required ApiService apiService,
    required LocalCacheService cacheService,
    required ConnectivityService connectivityService,
  })  : _apiService = apiService,
        _cacheService = cacheService,
        _connectivityService = connectivityService;

  final ApiService _apiService;
  final LocalCacheService _cacheService;
  final ConnectivityService _connectivityService;

  Future<List<QuizQuestion>> loadQuestions(String categoryId) async {
    if (await _connectivityService.isConnected) {
      final questions = await _apiService.fetchQuestions(categoryId: categoryId);
      unawaited(_cacheService.cacheQuestions(categoryId, questions));
      return questions;
    }
    final cached = _cacheService.readCachedQuestions(categoryId);
    if (cached == null || cached.isEmpty) {
      throw AppException('You are offline. No cached quiz available.');
    }
    return cached;
  }

  Future<void> saveResult(QuizResult result) async {
    await _cacheService.cacheResult(result);
  }

  List<QuizResult> loadCachedResults() {
    return _cacheService.allResults();
  }

  Future<void> syncPendingResults() async {
    if (!await _connectivityService.isConnected) return;
    final pending = _cacheService.pendingResults();
    if (pending.isEmpty) return;
    await Future<void>.delayed(const Duration(milliseconds: 500));
    for (final result in pending) {
      await _cacheService.markResultSynced(result);
    }
  }
}

