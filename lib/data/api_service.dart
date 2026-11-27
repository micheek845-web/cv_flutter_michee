import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'family_member.dart';

String _resolveBaseUrl(String? baseUrl) {
  final configuredUrl = const String.fromEnvironment('API_BASE_URL');
  final defaultUrl = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? 'http://10.0.2.2:8080/api-test/public'
      : 'http://localhost:8080/api-test/public';
  return (baseUrl ?? (configuredUrl.isEmpty ? defaultUrl : configuredUrl))
      .replaceFirst(RegExp(r'/+$'), '');
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = _resolveBaseUrl(baseUrl);

  final http.Client _client;
  final String _baseUrl;

  Uri _uri(String path) => Uri.parse('$_baseUrl$path');

  Future<dynamic> _request(Future<http.Response> request) async {
    final response = await request.timeout(const Duration(seconds: 20));
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw ApiException(
        'Réponse invalide du serveur (HTTP ${response.statusCode}).',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw const ApiException('Format de réponse invalide du serveur.');
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300 ||
        decoded['success'] != true) {
      final message = decoded['message'];
      throw ApiException(
        message is String ? message : 'Erreur API (${response.statusCode}).',
      );
    }
    return decoded['data'];
  }

  Map<String, String> get _headers => const {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  Future<void> login(String email, String password) async {
    await _request(
      _client.post(
        _uri('/accounts/login'),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );
  }

  Future<void> register(String email, String password) async {
    await _request(
      _client.post(
        _uri('/accounts/register'),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password}),
      ),
    );
  }

  Future<List<FamilyMember>> getFamilyMembers() async {
    final data = await _request(
      _client.get(_uri('/famille-membres'), headers: _headers),
    );
    if (data is! List) {
      throw const ApiException('La liste des membres reçue est invalide.');
    }
    return data.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const ApiException('Un membre reçu est invalide.');
      }
      return FamilyMember.fromJson(item);
    }).toList();
  }

  Future<void> createFamilyMember(Map<String, String> member) async {
    await _request(
      _client.post(
        _uri('/famille-membres'),
        headers: _headers,
        body: jsonEncode(member),
      ),
    );
  }

  Future<void> updateFamilyMember(int id, Map<String, String> member) async {
    await _request(
      _client.put(
        _uri('/famille-membres/$id'),
        headers: _headers,
        body: jsonEncode(member),
      ),
    );
  }

  Future<void> deleteFamilyMember(int id) async {
    await _request(
      _client.delete(_uri('/famille-membres/$id'), headers: _headers),
    );
  }

  void close() => _client.close();
}
