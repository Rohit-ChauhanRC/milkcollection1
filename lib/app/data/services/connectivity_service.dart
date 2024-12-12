import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService extends GetxController {
  var isConnected = false.obs;

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _listenToConnectivityChanges();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus(result);
    } catch (e) {
      print("Error checking connectivity: $e");
    }
  }

  // Listen to connectivity changes
  void _listenToConnectivityChanges() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  // Update the connection status based on the result
  void _updateConnectionStatus(List<ConnectivityResult> result) {
    isConnected.value = !result.contains(ConnectivityResult.none);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
