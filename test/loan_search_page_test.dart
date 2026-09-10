import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/presentation/pages/loan_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the shared renewal search form',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testApp(const LoanSearchPage(
      applicationType: LoanSearchPage.renewalType,
    )));

    final LoanSearchPage page = tester.widget<LoanSearchPage>(
      find.byType(LoanSearchPage),
    );
    expect(page.applicationType, 2);
    expect(find.text('Buscar crédito para renovación'), findsOneWidget);
    expect(find.text('Número de préstamo'), findsOneWidget);
    expect(find.text('CURP'), findsOneWidget);
    expect(find.text('Nombres'), findsOneWidget);
    expect(find.text('Apellido paterno'), findsOneWidget);
    expect(find.text('Apellido materno'), findsOneWidget);
    expect(find.text('Buscar'), findsOneWidget);

    final List<Key?> fieldKeys = tester
        .widgetList<TextFormField>(find.byType(TextFormField))
        .map((TextFormField field) => field.key)
        .toList();
    expect(
      fieldKeys,
      <Key>[
        const Key('loan-number-field'),
        const Key('loan-curp-field'),
        const Key('loan-name-field'),
        const Key('loan-lastname-field'),
        const Key('loan-surname-field'),
      ],
    );
  });

  testWidgets('keeps search values when the customer is cancelled',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testApp(LoanSearchPage(
      applicationType: LoanSearchPage.renewalType,
      lookupCustomer: ({required String loanNumber, required String curp}) async {
        expect(loanNumber, '15');
        expect(curp, '');
        return _customer;
      },
    )));

    await tester.enterText(find.byKey(const Key('loan-number-field')), '15');
    await tester.tap(find.byKey(const Key('loan-search-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text(
        'Se encontró al cliente MAYRA LIZET, ALVAREZ, TOLENTINO '
        '¿desea continuar con la captura del crédito?',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(_textOf(tester, 'loan-number-field'), '15');
    expect(_textOf(tester, 'loan-name-field'), _customer.name);
    expect(_textOf(tester, 'loan-lastname-field'), _customer.lastname);
    expect(_textOf(tester, 'loan-surname-field'), _customer.surname);
    expect(find.byType(LoanSearchPage), findsOneWidget);
  });

  testWidgets('returns the customer when reentry is confirmed',
      (WidgetTester tester) async {
    CustomerLookupResult? selectedCustomer;
    await tester.pumpWidget(_testApp(LoanSearchPage(
      applicationType: LoanSearchPage.reentryType,
      lookupCustomer: ({required String loanNumber, required String curp}) async {
        expect(loanNumber, '');
        expect(curp, 'AATM980401MMNLLY05');
        return _customer;
      },
      onCustomerSelected: (CustomerLookupResult customer) {
        selectedCustomer = customer;
      },
    )));

    await tester.enterText(
      find.byKey(const Key('loan-curp-field')),
      'aatm980401mmnlly05',
    );
    await tester.tap(find.byKey(const Key('loan-search-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(selectedCustomer?.id, 84542);

    final LoanSearchPage page = tester.widget<LoanSearchPage>(
      find.byType(LoanSearchPage),
    );
    expect(page.applicationType, 3);
  });
}

Widget _testApp(LoanSearchPage page) {
  return ProviderScope(
    child: MaterialApp(home: Scaffold(body: page)),
  );
}

String _textOf(WidgetTester tester, String key) {
  return tester
      .widget<TextFormField>(find.byKey(Key(key)))
      .controller!
      .text;
}

const CustomerLookupResult _customer = CustomerLookupResult(
  id: 84542,
  lastname: 'ALVAREZ',
  surname: 'TOLENTINO',
  name: 'MAYRA LIZET',
  gender: 0,
  street: 'ART 123',
  betweenStreets: '',
  extNum: 'SN',
  intNum: '',
  suburb: 'TANACO',
  city: 24,
  state: 16,
  zipCode: '60271',
  phoneNumber: null,
  maritalStatus: 0,
  curp: 'AATM980401MMNLLY05',
);
