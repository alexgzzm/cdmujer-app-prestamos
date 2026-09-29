import 'dart:async';

import 'package:cdmujer_app_prestamos/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/core/network/session_aware_client.dart';
import 'package:cdmujer_app_prestamos/features/auth/data/datasources/session_local_data_source.dart';
import 'package:cdmujer_app_prestamos/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/errors/session_expired_exception.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final Provider<http.Client> httpClientProvider =
    Provider<http.Client>((Ref ref) {
  final http.Client client = SessionAwareClient(
    inner: http.Client(),
    onUnauthorized: (String token) {
      ref.read(authControllerProvider.notifier).expireSession(token);
    },
  );
  ref.onDispose(client.close);
  return client;
});

final StateProvider<bool> sessionExpiredProvider =
    StateProvider<bool>((Ref ref) => false);

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>((Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource:
        AuthRemoteDataSource(client: ref.watch(httpClientProvider)),
    localDataSource: SessionLocalDataSource(),
  );
});

final AsyncNotifierProvider<AuthController, AuthSession?>
    authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  Timer? _expiryTimer;

  @override
  Future<AuthSession?> build() async {
    ref.onDispose(() => _expiryTimer?.cancel());
    try {
      final AuthSession? session =
          await ref.read(authRepositoryProvider).readSession();
      if (session == null) return null;
      if (session.isExpiredAt(DateTime.now())) {
        await ref.read(authRepositoryProvider).signOut();
        ref.read(sessionExpiredProvider.notifier).state = true;
        return null;
      }
      _scheduleExpiration(session);
      return session;
    } on SessionExpiredException {
      ref.read(sessionExpiredProvider.notifier).state = true;
      return null;
    }
  }

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    _expiryTimer?.cancel();
    state = const AsyncLoading<AuthSession?>();
    state = await AsyncValue.guard<AuthSession?>(
      () => ref.read(authRepositoryProvider).signIn(
            username: username,
            password: password,
          ),
    );
    if (state.hasValue && state.value != null) {
      ref.read(sessionExpiredProvider.notifier).state = false;
      _scheduleExpiration(state.value!);
    }
  }

  void checkSessionExpiry() {
    final AuthSession? session = state.whenOrNull(
      data: (AuthSession? value) => value,
    );
    if (session != null && session.isExpiredAt(DateTime.now())) {
      unawaited(expireSession(session.token));
    }
  }

  void _scheduleExpiration(AuthSession session) {
    _expiryTimer?.cancel();
    final Duration remaining =
        session.expiresAt.difference(DateTime.now().toUtc());
    _expiryTimer =
        Timer(remaining > Duration.zero ? remaining : Duration.zero, () {
      unawaited(expireSession(session.token));
    });
  }

  Future<void> expireSession(String token) async {
    final AuthSession? session = state.whenOrNull(
      data: (AuthSession? value) => value,
    );
    if (session == null ||
        session.token != token ||
        ref.read(sessionExpiredProvider)) {
      return;
    }

    _expiryTimer?.cancel();
    state = const AsyncData<AuthSession?>(null);
    try {
      await ref.read(authRepositoryProvider).signOut();
    } on Object {
      // The session is already invalid; keep the user on the login screen.
    } finally {
      ref.read(sessionExpiredProvider.notifier).state = true;
    }
  }

  Future<bool> signOut() async {
    _expiryTimer?.cancel();
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
