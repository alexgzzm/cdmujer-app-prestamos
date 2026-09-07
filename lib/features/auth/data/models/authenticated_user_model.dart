import 'package:cdmujer_app_prestamos/features/auth/domain/entities/authenticated_user.dart';

class AuthenticatedUserModel extends AuthenticatedUser {
  const AuthenticatedUserModel({
    required super.id,
    required super.username,
    required super.roleId,
    required super.name,
  });

  factory AuthenticatedUserModel.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUserModel(
      id: json['id_User'] as int,
      username: json['username'] as String,
      roleId: json['id_Rol'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id_User': id,
      'username': username,
      'id_Rol': roleId,
      'name': name,
    };
  }
}
