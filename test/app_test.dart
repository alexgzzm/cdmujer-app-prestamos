import 'package:cdmujer_app_prestamos/app/app.dart';
import 'package:cdmujer_app_prestamos/core/constants/app_branding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('shows the login form', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.text('Nombre de usuario'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Ingresar'), findsOneWidget);

    final Image logo = tester.widget<Image>(find.byType(Image));
    final AssetImage imageProvider = logo.image as AssetImage;
    expect(imageProvider.assetName, AppBranding.logoAsset);
  });
}
