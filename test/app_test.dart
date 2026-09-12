import 'package:cdmujer_app_prestamos/app/app.dart';
import 'package:cdmujer_app_prestamos/core/constants/app_branding.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
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
}

class _LoggedOutAuthController extends AuthController {
  @override
  Future<AuthSession?> build() async => null;
}
