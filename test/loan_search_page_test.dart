import 'package:cdmujer_app_prestamos/features/loan_search/presentation/pages/loan_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the shared renewal search form',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoanSearchPage(
            applicationType: LoanSearchPage.renewalType,
          ),
        ),
      ),
    );

    final LoanSearchPage page = tester.widget<LoanSearchPage>(
      find.byType(LoanSearchPage),
    );
    expect(page.applicationType, 2);
    expect(find.text('Buscar crédito para renovación'), findsOneWidget);
    expect(find.text('Número de préstamo'), findsOneWidget);
    expect(find.text('CURP'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Buscar'), findsOneWidget);

    await tester.tap(find.byKey(const Key('loan-search-button')));
    await tester.pump();
    expect(find.byType(LoanSearchPage), findsOneWidget);
  });

  testWidgets('identifies reentry with application type 3',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoanSearchPage(
            applicationType: LoanSearchPage.reentryType,
          ),
        ),
      ),
    );

    final LoanSearchPage page = tester.widget<LoanSearchPage>(
      find.byType(LoanSearchPage),
    );
    expect(page.applicationType, 3);
    expect(find.text('Buscar crédito para reingreso'), findsOneWidget);
  });
}
