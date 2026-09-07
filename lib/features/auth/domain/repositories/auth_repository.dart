import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession> signIn({
    required String username,
    required String password,
  });
}
