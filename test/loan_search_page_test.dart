import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_name_match.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/presentation/pages/loan_search_page.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_information_validation.dart';
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

  testWidgets('keeps exact search criteria when the customer is cancelled',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testApp(LoanSearchPage(
      applicationType: LoanSearchPage.renewalType,
      lookupCustomer: ({required String loanNumber, required String curp}) async {
        expect(loanNumber, '15');
        expect(curp, '');
        return _customer;
      },
      validateCustomer: ({
        required String curp,
        required int idCustomer,
      }) async {
        expect(curp, _customer.curp);
        expect(idCustomer, _customer.id);
        return _successfulValidation;
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
    expect(_textOf(tester, 'loan-name-field'), isEmpty);
    expect(_textOf(tester, 'loan-lastname-field'), isEmpty);
    expect(_textOf(tester, 'loan-surname-field'), isEmpty);
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
      validateCustomer: ({
        required String curp,
        required int idCustomer,
      }) async {
        expect(curp, _customer.curp);
        expect(idCustomer, _customer.id);
        return _successfulValidation;
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
    expect(_textOf(tester, 'loan-name-field'), isEmpty);
    expect(_textOf(tester, 'loan-lastname-field'), isEmpty);
    expect(_textOf(tester, 'loan-surname-field'), isEmpty);
  });

  testWidgets('requires all three name fields for a name search',
      (WidgetTester tester) async {
    bool searched = false;
    await tester.pumpWidget(_testApp(LoanSearchPage(
      applicationType: LoanSearchPage.renewalType,
      lookupCustomersByName: ({
        required String name,
        required String lastname,
        required String surname,
      }) async {
        searched = true;
        return const <CustomerNameMatch>[];
      },
    )));

    await tester.enterText(
      find.byKey(const Key('loan-name-field')),
      'Teresa',
    );
    await tester.ensureVisible(find.byKey(const Key('loan-search-button')));
    await tester.tap(find.byKey(const Key('loan-search-button')));
    await tester.pump();

    expect(searched, isFalse);
    expect(
      find.text(
        'Para buscar por nombre, captura nombres, apellido paterno y apellido materno.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('shows name matches and loads the selected customer',
      (WidgetTester tester) async {
    CustomerLookupResult? selectedCustomer;
    await tester.pumpWidget(_testApp(LoanSearchPage(
      applicationType: LoanSearchPage.renewalType,
      lookupCustomersByName: ({
        required String name,
        required String lastname,
        required String surname,
      }) async {
        expect(name, 'TERESA');
        expect(lastname, 'FLORES');
        expect(surname, 'AVIÑA');
        return const <CustomerNameMatch>[_nameMatch];
      },
      lookupCustomer: ({required String loanNumber, required String curp}) async {
        expect(loanNumber, '');
        expect(curp, _nameMatch.curp);
        return _customer;
      },
      validateCustomer: ({
        required String curp,
        required int idCustomer,
      }) async {
        expect(curp, _customer.curp);
        expect(idCustomer, _customer.id);
        return _successfulValidation;
      },
      onCustomerSelected: (CustomerLookupResult customer) {
        selectedCustomer = customer;
      },
    )));

    await tester.enterText(
      find.byKey(const Key('loan-name-field')),
      'teresa',
    );
    await tester.enterText(
      find.byKey(const Key('loan-lastname-field')),
      'flores',
    );
    await tester.enterText(
      find.byKey(const Key('loan-surname-field')),
      'aviña',
    );
    await tester.ensureVisible(find.byKey(const Key('loan-search-button')));
    await tester.tap(find.byKey(const Key('loan-search-button')));
    await tester.pumpAndSettle();

    expect(find.text('TERESA FLORES AVIÑA'), findsOneWidget);
    expect(find.text('CURP: FOAT641212MMNLVR02'), findsOneWidget);
    expect(find.text('Último préstamo: 105'), findsOneWidget);
    expect(find.text('Ruta: RUTA 1'), findsOneWidget);
    expect(find.text('Grupo: GRUPO A'), findsOneWidget);

    final Finder matchCard = find.byKey(const Key('customer-match-11'));
    await tester.ensureVisible(matchCard);
    await tester.tap(matchCard);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(selectedCustomer?.id, _customer.id);
  });

  testWidgets('blocks the application when customer validation fails',
      (WidgetTester tester) async {
    CustomerLookupResult? selectedCustomer;
    await tester.pumpWidget(_testApp(LoanSearchPage(
      applicationType: LoanSearchPage.renewalType,
      lookupCustomer: ({required String loanNumber, required String curp}) async {
        return _customer;
      },
      validateCustomer: ({
        required String curp,
        required int idCustomer,
      }) async {
        expect(curp, _customer.curp);
        expect(idCustomer, _customer.id);
        return const LoanInformationValidation(
          id: 84542,
          status: false,
          message: 'El cliente tiene un préstamo abierto.',
          messageType: LoanValidationMessageType.error,
        );
      },
      onCustomerSelected: (CustomerLookupResult customer) {
        selectedCustomer = customer;
      },
    )));

    await tester.enterText(find.byKey(const Key('loan-number-field')), '15');
    await tester.tap(find.byKey(const Key('loan-search-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('No es posible continuar'), findsOneWidget);
    expect(find.text('El cliente tiene un préstamo abierto.'), findsOneWidget);
    expect(find.text('Cliente encontrado'), findsNothing);
    expect(selectedCustomer, isNull);
  });

  testWidgets('continues after a customer validation warning',
      (WidgetTester tester) async {
    await tester.pumpWidget(_testApp(LoanSearchPage(
      applicationType: LoanSearchPage.reentryType,
      lookupCustomer: ({required String loanNumber, required String curp}) async {
        return _customer;
      },
      validateCustomer: ({
        required String curp,
        required int idCustomer,
      }) async {
        expect(idCustomer, _customer.id);
        return const LoanInformationValidation(
          id: 84542,
          status: false,
          message: 'El cliente tiene información por revisar.',
          messageType: LoanValidationMessageType.warning,
        );
      },
    )));

    await tester.enterText(find.byKey(const Key('loan-number-field')), '15');
    await tester.tap(find.byKey(const Key('loan-search-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Advertencia'), findsOneWidget);
    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();

    expect(find.text('Cliente encontrado'), findsOneWidget);
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

final CustomerLookupResult _customer = CustomerLookupResult(
  id: 84542,
  lastname: 'ALVAREZ',
  surname: 'TOLENTINO',
  name: 'MAYRA LIZET',
  birthDate: DateTime.utc(1998, 4, 1),
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

const CustomerNameMatch _nameMatch = CustomerNameMatch(
  id: 11,
  name: 'TERESA FLORES AVIÑA',
  curp: 'FOAT641212MMNLVR02',
  lastLoan: '105',
  loanRoute: 'RUTA 1',
  loanGroup: 'GRUPO A',
);

const LoanInformationValidation _successfulValidation =
    LoanInformationValidation(
  id: null,
  status: true,
  message: 'El cliente puede continuar.',
  messageType: LoanValidationMessageType.success,
);
