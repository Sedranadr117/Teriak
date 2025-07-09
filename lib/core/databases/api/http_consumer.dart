import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teriak/core/databases/api/api_consumer.dart';
import 'package:teriak/core/errors/expentions.dart';

class HttpConsumer extends ApiConsumer {
  final String baseUrl;

  HttpConsumer({required this.baseUrl});

  @override
  Future<dynamic> get(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
      final response = await http.get(uri);
      handleHttpResponse(response);
      return _tryDecode(response.body);
    } catch (e) {
      handleHttpException(e);
    }
  }

  @override
  Future<dynamic> post(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);

      print('🌐 Full URL: $uri');
      print('📤 Request method: POST');
      print('📦 Request data: $data');

      final headers = {
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      };
      print('📋 Headers: $headers');

      final body = isFormData ? data : json.encode(data);
      print('📄 Request body: $body');

      final response = await http.post(uri, body: body, headers: headers);

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      handleHttpResponse(response);
      return _tryDecode(response.body);
    } catch (e) {
      print('💥 HTTP Error: $e');
      handleHttpException(e);
    }
  }

  @override
  Future<dynamic> patch(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      bool isFormData = false}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
      final headers = {
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      };
      final body = isFormData ? data : json.encode(data);
      final response = await http.patch(uri, body: body, headers: headers);
      handleHttpResponse(response);
      return _tryDecode(response.body);
    } catch (e) {
      handleHttpException(e);
    }
  }

  @override
  Future<dynamic> delete(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
      final response =
          await http.delete(uri, body: data != null ? json.encode(data) : null);
      handleHttpResponse(response);
      return _tryDecode(response.body);
    } catch (e) {
      handleHttpException(e);
    }
  }

  dynamic _tryDecode(String body) {
    try {
      return json.decode(body);
    } catch (_) {
      return body;
    }
  }
}
