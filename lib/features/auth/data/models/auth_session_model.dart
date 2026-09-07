import 'package:cdmujer_app_prestamos/features/auth/data/models/authenticated_user_model.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';

class AuthSessionModel extends AuthSession {
  const AuthSessionModel({required super.token, required super.user});

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      token: json['token'] as String,
      user: AuthenticatedUserModel.fromJson(json['userInfo'] as Map<String, dynamic>),
    );
  }
}
