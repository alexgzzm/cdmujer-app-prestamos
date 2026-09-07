import 'dart:convert';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/features/auth/data/models/auth_session_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  AuthRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<AuthSessionModel> signIn({
    required String username,
    required String password,
  }) async {
    try {
      final http.Response response = await _client.post(
        ApiConfig.authEndpoint,
        headers: const <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'usuario': username,
          'password': password,
        }),
      );

      final dynamic responseBody = response.body.isEmpty
          ? null
          : jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AuthException(_messageFrom(responseBody));
      }

      if (responseBody is! Map<String, dynamic>) {
        throw const AuthException('La respuesta del servidor no es válida.');
      }

      return AuthSessionModel.fromJson(responseBody);
    } on AuthException {
      rethrow;
    } on FormatException {
      throw const AuthException('La respuesta del servidor no es válida.');
    } on http.ClientException {
      throw const AuthException('No fue posible conectar con el servidor.');
    }
  }

  String _messageFrom(dynamic responseBody) {
    if (responseBody is Map<String, dynamic>) {
      final dynamic message = responseBody['message'] ??
          responseBody['error'] ??
          responseBody['detail'] ??
          responseBody['title'];
      if (message is String && message.isNotEmpty) {
        return message;
      }

      final dynamic errors = responseBody['errors'];
      if (errors is Map<String, dynamic>) {
        final Iterable<String> messages = errors.values
            .expand<String>((dynamic value) => value is List
                ? value.whereType<String>()
                : value is String
                    ? <String>[value]
                    : <String>[])
            .where((String value) => value.isNotEmpty);
        if (messages.isNotEmpty) {
          return messages.join('\n');
        }
      }
    }
    return 'No fue posible iniciar sesión.';
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}
