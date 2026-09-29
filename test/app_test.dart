import 'package:cdmujer_app_prestamos/app/app.dart';
import 'package:cdmujer_app_prestamos/app/router/app_router.dart';
import 'package:cdmujer_app_prestamos/core/constants/app_branding.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/authenticated_user.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/repositories/auth_repository.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('shows the login form', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          authControllerProvider.overrideWith(_LoggedOutAuthController.new),
        ],
        child: const App(),
      ),
    );
    await tester.pump();

    expect(find.text('Nombre de usuario'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);

    final Image logo = tester.widget<Image>(find.byType(Image));
    final AssetImage imageProvider = logo.image as AssetImage;
    expect(imageProvider.assetName, AppBranding.logoAsset);
  });

  testWidgets('redirects to login and shows a message when the session expires',
      (WidgetTester tester) async {
    final _FakeAuthRepository repository = _FakeAuthRepository();
    appRouter.go('/login');
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          authRepositoryProvider.overrideWithValue(repository),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    appRouter.go('/home');
    await tester.pumpAndSettle();
    final ProviderContainer container =
        ProviderScope.containerOf(tester.element(find.byType(App)));
    await container
        .read(authControllerProvider.notifier)
        .expireSession('token');
    await tester.pumpAndSettle();

    expect(find.text('Nombre de usuario'), findsOneWidget);
    expect(find.text('Sesión caducada'), findsOneWidget);
    expect(repository.signOutCount, 1);
    expect(container.read(authControllerProvider).value, isNull);
  });

  testWidgets('expires an active session after 15 hours without an API call',
      (WidgetTester tester) async {
    final _FakeAuthRepository repository = _FakeAuthRepository();
    appRouter.go('/login');
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          authRepositoryProvider.overrideWithValue(repository),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    appRouter.go('/home');
    await tester.pumpAndSettle();

    await tester.pump(const Duration(hours: 15));
    await tester.pumpAndSettle();

    expect(find.text('Nombre de usuario'), findsOneWidget);
    expect(find.text('Sesión caducada'), findsOneWidget);
    expect(repository.signOutCount, 1);
  });

  testWidgets('expires a stored session that is already 15 hours old',
      (WidgetTester tester) async {
    final _FakeAuthRepository repository = _FakeAuthRepository(
      createdAt: DateTime.now().toUtc().subtract(const Duration(hours: 15)),
    );
    appRouter.go('/login');
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          authRepositoryProvider.overrideWithValue(repository),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nombre de usuario'), findsOneWidget);
    expect(find.text('Sesión caducada'), findsOneWidget);
    expect(repository.signOutCount, 1);
  });
}

class _LoggedOutAuthController extends AuthController {
  @override
  Future<AuthSession?> build() async => null;
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now().toUtc();

  final DateTime createdAt;
  int signOutCount = 0;

  @override
  Future<AuthSession?> readSession() async => AuthSession(
        token: 'token',
        createdAt: createdAt,
        user: const AuthenticatedUser(
          id: 1,
          username: 'user',
          roleId: 1,
          name: 'User',
        ),
      );

  @override
  Future<AuthSession> signIn(
      {required String username, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    signOutCount++;
  }
}
