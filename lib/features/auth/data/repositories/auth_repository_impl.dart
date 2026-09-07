import 'package:cdmujer_app_prestamos/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/auth/data/datasources/session_local_data_source.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SessionLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final SessionLocalDataSource _localDataSource;

  @override
  Future<AuthSession> signIn({
    required String username,
    required String password,
  }) async {
    final AuthSession session = await _remoteDataSource.signIn(
      username: username,
      password: password,
    );
    await _localDataSource.save(session);
    return session;
  }
}
