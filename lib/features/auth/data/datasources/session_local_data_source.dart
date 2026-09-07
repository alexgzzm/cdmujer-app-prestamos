import 'dart:convert';

import 'package:cdmujer_app_prestamos/features/auth/data/models/auth_session_model.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SessionLocalDataSource {
  SessionLocalDataSource({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  final FlutterSecureStorage _storage;

  Future<void> save(AuthSession session) async {
    await _storage.write(key: _tokenKey, value: session.token);
    await _storage.write(
      key: _userKey,
      value: jsonEncode(<String, dynamic>{
        'id_User': session.user.id,
        'username': session.user.username,
        'id_Rol': session.user.roleId,
        'name': session.user.name,
      }),
    );
  }

  Future<AuthSessionModel?> read() async {
    final List<String?> values = await Future.wait<String?>(<Future<String?>>[
      _storage.read(key: _tokenKey),
      _storage.read(key: _userKey),
    ]);
    final String? token = values[0];
    final String? encodedUser = values[1];

    if (token == null || encodedUser == null) {
      return null;
    }

    try {
      return AuthSessionModel.fromJson(<String, dynamic>{
        'token': token,
        'userInfo': jsonDecode(encodedUser),
      });
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  Future<void> clear() async {
    await Future.wait<void>(<Future<void>>[
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _userKey),
    ]);
  }
}
