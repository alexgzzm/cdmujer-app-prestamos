import 'package:cdmujer_app_prestamos/features/auth/domain/entities/authenticated_user.dart';

class AuthSession {
  const AuthSession({
    required this.token,
    required this.user,
    required this.createdAt,
  });

  static const Duration validity = Duration(hours: 15);

  final String token;
  final AuthenticatedUser user;
  final DateTime createdAt;

  DateTime get expiresAt => createdAt.add(validity);

  bool isExpiredAt(DateTime time) => !time.toUtc().isBefore(expiresAt);
}
