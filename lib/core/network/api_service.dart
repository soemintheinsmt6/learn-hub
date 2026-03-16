import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:learn_hub/core/app_config.dart';
import 'package:learn_hub/core/error/api_exception.dart';

class ApiService {
  final baseUrl = '${AppConfig.baseUrl}/';

  final head = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  @visibleForTesting
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @visibleForTesting
  Future<Map<String, String>> getHeaders(bool isRequiredToken) async {
    if (!isRequiredToken) return head;

    final token = await storage.read(key: 'token');

    return {...head, if (token != null) "Authorization": "Bearer $token"};
  }

  Future<dynamic> get(String endpoint, {bool isRequiredToken = true}) async {
    final headers = await getHeaders(isRequiredToken);
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
    );

    return handleResponse(response, endpoint);
  }

  // For external APIs
  Future<Map<String, dynamic>> getExternal(String fullUrl) async {
    final response = await http.get(Uri.parse(fullUrl), headers: head);

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool isRequiredToken = true,
  }) async {
    final headers = await getHeaders(isRequiredToken);
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
      body: jsonEncode(body),
    );
    return handleResponse(response, endpoint);
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool isRequiredToken = true,
  }) async {
    final headers = await getHeaders(isRequiredToken);
    final response = await http.delete(
      Uri.parse("$baseUrl$endpoint"),
      headers: headers,
    );
    return handleResponse(response, endpoint);
  }

  @visibleForTesting
  dynamic handleResponse(http.Response response, String endPoint) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw ApiException(
        data["message"] ??
            "Failed to request $endPoint: status code: ${response.statusCode}",
      );
    }
  }
}
