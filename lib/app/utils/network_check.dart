import 'package:flutter/services.dart';

class NetworkCheck {
  static const MethodChannel _channel = MethodChannel('network_info');

  static Future<String?> getNetworkType() async {
    try {
      final String? networkType = await _channel.invokeMethod('getNetworkType');
      return networkType;
    } on PlatformException catch (e) {
      return "Failed to get network type: '${e.message}'.";
    }
  }
}
