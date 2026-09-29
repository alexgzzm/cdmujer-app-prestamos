import 'package:cdmujer_app_prestamos/features/auth/data/models/authenticated_user_model.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({
    required super.token,
    required super.user,
    required super.createdAt,
  });

  factory AuthSessionModel.fromJson(
    Map<String, dynamic> json, {
    DateTime? createdAt,
  }) {
    return AuthSessionModel(
      token: json['token'] as String,
      user: AuthenticatedUserModel.fromJson(
          json['userInfo'] as Map<String, dynamic>),
      createdAt: createdAt ?? DateTime.now().toUtc(),
    );
  }
}
