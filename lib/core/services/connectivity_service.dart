import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'logger_service.dart';

class ConnectivityService extends GetxService with WidgetsBindingObserver {
  ConnectivityService({required this._logger, Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  final LoggerService _logger;
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final RxBool _hasNetworkConnection = false.obs;

  final RxBool _initialized = false.obs;

  final RxList<ConnectivityResult> _connections = <ConnectivityResult>[].obs;

  bool get hasNetworkConnection => _hasNetworkConnection.value;

  @override
  bool get initialized => _initialized.value;

  List<ConnectivityResult> get connections => List.unmodifiable(_connections);

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this);

    _subscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityChanged,
      onError: (Object error, StackTrace stackTrace) {
        _logger.warning(
          'Connectivity stream error.',
          error: error,
          stackTrace: stackTrace,
          name: 'ConnectivityService',
        );
      },
    );

    unawaited(refresh());
  }

  Future<void> refresh() async {
    try {
      final results = await _connectivity.checkConnectivity();

      _handleConnectivityChanged(results);

      _initialized.value = true;
    } catch (error, stackTrace) {
      _initialized.value = true;

      _logger.warning(
        'Unable to determine network connectivity.',
        error: error,
        stackTrace: stackTrace,
        name: 'ConnectivityService',
      );
    }
  }

  void _handleConnectivityChanged(List<ConnectivityResult> results) {
    _connections.assignAll(results);

    _hasNetworkConnection.value = results.any(
      (result) => result != ConnectivityResult.none,
    );

    _logger.debug(
      'Connectivity changed: $results',
      name: 'ConnectivityService',
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(refresh());
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);

    final subscription = _subscription;

    if (subscription != null) {
      unawaited(subscription.cancel());
    }

    super.onClose();
  }
}
