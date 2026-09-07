import 'package:cdmujer_app_prestamos/features/auth/domain/entities/authenticated_user.dart';

class AuthSession {
  const AuthSession({required this.token, required this.user});

  final String token;
  final AuthenticatedUser user;
}
