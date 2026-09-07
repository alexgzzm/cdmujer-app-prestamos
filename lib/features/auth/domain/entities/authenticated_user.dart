class AuthenticatedUser {
  const AuthenticatedUser({
    required this.id,
    required this.username,
    required this.roleId,
    required this.name,
  });

  final int id;
  final String username;
  final int roleId;
  final String name;
}
