import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      // First check basic connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('📡 No network connectivity detected');
        return false;
      }

      // Then try to make a simple HTTP request to verify internet access
      try {
        final response = await http
            .get(Uri.parse('https://www.google.com'))
            .timeout(const Duration(seconds: 5));
        print('📡 Internet connectivity confirmed via HTTP test');
        return response.statusCode == 200;
      } catch (e) {
        print('📡 HTTP test failed, trying alternative method: $e');

        // Fallback: try to connect to a known IP
        try {
          final socket = await Socket.connect('8.8.8.8', 53,
              timeout: const Duration(seconds: 5));
          await socket.close();
          print('📡 Internet connectivity confirmed via socket test');
          return true;
        } catch (e) {
          print('📡 Socket test also failed: $e');
          return false;
        }
      }
    } catch (e) {
      print('📡 Network check error: $e');
      return false;
    }
  }
}
