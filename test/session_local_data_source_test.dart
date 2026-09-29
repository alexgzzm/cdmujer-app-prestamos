import 'package:cdmujer_app_prestamos/features/auth/data/datasources/session_local_data_source.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/authenticated_user.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/errors/session_expired_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => FlutterSecureStorage.setMockInitialValues(<String, String>{}));

  test('persists the token creation time across app launches', () async {
    final SessionLocalDataSource source = SessionLocalDataSource();
    final DateTime createdAt = DateTime.utc(2026, 9, 28, 8);
    await source.save(AuthSession(
      token: 'token',
      createdAt: createdAt,
      user: const AuthenticatedUser(
        id: 1,
        username: 'user',
        roleId: 1,
        name: 'User',
      ),
    ));

    final AuthSession? restored = await SessionLocalDataSource().read();

    expect(restored?.token, 'token');
    expect(restored?.createdAt, createdAt);
    await source.clear();
    expect(await source.read(), isNull);
  });

  test('clears a legacy session without a creation time', () async {
    FlutterSecureStorage.setMockInitialValues(<String, String>{
      'auth_token': 'legacy-token',
      'auth_user': '{"id_User":1,"username":"user","id_Rol":1,"name":"User"}',
    });
    final SessionLocalDataSource source = SessionLocalDataSource();

    await expectLater(source.read(), throwsA(isA<SessionExpiredException>()));
    expect(await const FlutterSecureStorage().read(key: 'auth_token'), isNull);
  });
}
