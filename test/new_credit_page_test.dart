import 'package:cdmujer_app_prestamos/features/new_credit/presentation/pages/new_credit_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('moves through the new credit wizard',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: NewCreditPage())),
    );

    expect(find.text('Datos del cliente'), findsOneWidget);

    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    expect(find.text('Datos del aval'), findsOneWidget);

    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    expect(find.text('Información del crédito'), findsOneWidget);
  });
}
