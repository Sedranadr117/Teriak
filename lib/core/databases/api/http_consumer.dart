import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:teriak/core/databases/api/api_consumer.dart';
import 'package:teriak/core/databases/cache/cache_helper.dart';
import 'package:teriak/core/errors/expentions.dart';

class HttpConsumer extends ApiConsumer {
  final String baseUrl;
  final CacheHelper cacheHelper;

  HttpConsumer({required this.baseUrl, required this.cacheHelper});

  Map<String, String> _getHeaders({bool isFormData = false}) {
    final headers = {
      'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
    };

    // Add authorization token if available
    final token = cacheHelper.getDataString(key: 'token');
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      print('🔑 Adding token to headers: Bearer $token');
    } else {
      print('⚠️ No token found in cache');
    }

    return headers;
  }

  @override
  Future<dynamic> get(String path,
      {Object? data, Map<String, dynamic>? queryParameters}) async {
    try {
      final uri =
          Uri.parse('$baseUrl$path').replace(queryParameters: queryParameters);
      final headers = _getHeaders();
      final response = await http.get(uri, headers: headers);
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

      final headers = _getHeaders(isFormData: isFormData);
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
      rethrow;
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
      final headers = _getHeaders(isFormData: isFormData);
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
      final headers = _getHeaders();
      final response = await http.delete(uri,
          body: data != null ? json.encode(data) : null, headers: headers);
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
