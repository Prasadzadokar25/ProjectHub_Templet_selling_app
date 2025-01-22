import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'global_navigation_key.dart'; // Import the global navigatorKey

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _subscription;

  ConnectivityService() {
    _initialize();
  }

  void _initialize() {
    log("000000000000000000000000000000000000000000000000000000000000000000000000");
    // Listen to connectivity changes
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        // Navigate to the No Internet screen globally
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/noInternet',
          (route) => false,
        );
      } else {
        // Optionally handle when connectivity is restored
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/splash',
          (route) => false,
        );
      }
    });
  }

  void dispose() {
    _subscription.cancel();
  }
}
