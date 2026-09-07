import 'package:cdmujer_app_prestamos/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/auth/data/datasources/session_local_data_source.dart';
import 'package:cdmujer_app_prestamos/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final Provider<http.Client> httpClientProvider = Provider<http.Client>((Ref ref) {
  final http.Client client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(client: ref.watch(httpClientProvider)),
    localDataSource: SessionLocalDataSource(),
  );
});

final AsyncNotifierProvider<AuthController, AuthSession?>
    authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() {
    return ref.read(authRepositoryProvider).readSession();
  }

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading<AuthSession?>();
    state = await AsyncValue.guard<AuthSession?>(
      () => ref.read(authRepositoryProvider).signIn(
            username: username,
            password: password,
          ),
    );
  }

  Future<bool> signOut() async {
    state = const AsyncLoading<AuthSession?>();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncData<AuthSession?>(null);
      return true;
    } on Object catch (error, stackTrace) {
      state = AsyncError<AuthSession?>(error, stackTrace);
      return false;
    }
  }
}
