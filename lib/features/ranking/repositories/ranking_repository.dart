import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quiz_learning_app/core/models/ranking_user.dart';

class RankingRepository {
  RankingRepository({this.assetPath = 'assets/mock/ranking.json'});

  final String assetPath;
  List<RankingUser>? _cache;

  Future<List<RankingUser>> loadRankings() async {
    if (_cache != null) return _cache!;
    final jsonString = await rootBundle.loadString(assetPath);
    final payload = jsonDecode(jsonString) as List<dynamic>;
    _cache = payload
        .map((json) => RankingUser.fromJson(Map<String, dynamic>.from(json as Map)))
        .toList();
    return _cache!;
  }
}

