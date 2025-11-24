import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_anyConnected).distinct();

  Future<bool> get isConnected async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    return _anyConnected(results);
  }

  bool _anyConnected(List<ConnectivityResult> results) {
    return results.any(_isConnected);
  }

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }
}

