import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/relationship_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/pages/cosigner_search_page.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/pages/new_credit_page.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/city_dropdown.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/credit_date_picker.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/relationship_dropdown.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/state_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('selects API behavior by application type', () {
    expect(
      NewCreditPage.shouldRunIneOcrFor(NewCreditPage.newCreditType),
      isTrue,
    );
    expect(NewCreditPage.shouldRunIneOcrFor(2), isFalse);
    expect(NewCreditPage.shouldRunIneOcrFor(3), isFalse);
    expect(
      NewCreditPage.shouldLoadLoanBalanceFor(NewCreditPage.renewalType),
      isTrue,
    );
    expect(
      NewCreditPage.shouldLoadLoanBalanceFor(NewCreditPage.newCreditType),
      isFalse,
    );
    expect(
      NewCreditPage.shouldLoadLoanBalanceFor(NewCreditPage.reentryType),
      isFalse,
    );
  });

  testWidgets('moves through the new credit wizard',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: NewCreditPage(
              lookupRelationships: _lookupRelationships,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Datos del cliente'), findsOneWidget);
    expect(find.text('Fecha de nacimiento'), findsOneWidget);
    expect(find.text('Género'), findsNothing);
    final CreditDatePicker clientBirthDatePicker =
        tester.widget<CreditDatePicker>(
      find.byKey(
        const Key('credit-date-picker-Fecha de nacimiento'),
      ),
    );
    expect(
      clientBirthDatePicker.lastDate,
      latestAdultBirthDate(DateTime.now()),
    );
    expect(find.text('INE Frontal'), findsOneWidget);
    expect(find.text('INE Reverso'), findsOneWidget);
    expect(find.byKey(const Key('proof-attachment-button')), findsNothing);
    final NewCreditPage page = tester.widget<NewCreditPage>(
      find.byType(NewCreditPage),
    );
    expect(page.applicationType, NewCreditPage.newCreditType);
    expect(find.byKey(const Key('return-to-search-button')), findsNothing);

    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    expect(find.text('Datos del aval'), findsOneWidget);
    expect(find.text('Fecha de nacimiento'), findsOneWidget);
    expect(find.text('Género'), findsNothing);
    expect(find.byKey(const Key('search-cosigner-button')), findsOneWidget);
    final double searchButtonTop = tester
        .getTopLeft(find.byKey(const Key('search-cosigner-button')))
        .dy;
    final double frontIneButtonTop = tester
        .getTopLeft(find.widgetWithText(OutlinedButton, 'INE Frontal'))
        .dy;
    final double backIneButtonTop = tester
        .getTopLeft(find.widgetWithText(OutlinedButton, 'INE Reverso'))
        .dy;
    expect(searchButtonTop, frontIneButtonTop);
    expect(searchButtonTop, backIneButtonTop);
    expect(find.byKey(const Key('proof-attachment-button')), findsNothing);

    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Información del crédito'), findsOneWidget);
    expect(find.byKey(const Key('proof-attachment-button')), findsOneWidget);
    expect(find.text('Comprobante'), findsOneWidget);
    expect(find.text('Plazo'), findsOneWidget);
    expect(find.byType(RelationshipDropdown), findsOneWidget);
    expect(find.text('Esposo (a)'), findsOneWidget);
    expect(find.text('Monto Adeudado'), findsOneWidget);
    expect(find.text('Monto a Entregar'), findsOneWidget);
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const Key('outstanding-amount-field')),
          )
          .readOnly,
      isTrue,
    );
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const Key('amount-to-deliver-field')),
          )
          .readOnly,
      isTrue,
    );
    final TextFormField termField = tester.widget<TextFormField>(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is TextFormField && widget.decoration?.labelText == 'Plazo',
      ),
    );
    expect(termField.controller!.text, '14');
    expect(find.text('Método de pago'), findsNothing);
  });

  testWidgets('opens the cosigner search from step two',
      (WidgetTester tester) async {
    final GoRouter router = GoRouter(
      initialLocation: '/new-credit',
      routes: <RouteBase>[
        GoRoute(
          path: '/new-credit',
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(body: NewCreditPage());
          },
        ),
        GoRoute(
          path: '/cosigner-search',
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(body: CosignerSearchPage());
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );

    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('search-cosigner-button')));
    await tester.pumpAndSettle();

    expect(find.text('Buscar aval'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(3));

    await tester.tap(
      find.byKey(const Key('return-to-cosigner-form-button')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Datos del aval'), findsOneWidget);
    expect(find.byKey(const Key('search-cosigner-button')), findsOneWidget);
  });

  testWidgets('fills the cosigner form with the selected customer',
      (WidgetTester tester) async {
    final GoRouter router = GoRouter(
      initialLocation: '/new-credit',
      routes: <RouteBase>[
        GoRoute(
          path: '/new-credit',
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold(body: NewCreditPage());
          },
        ),
        GoRoute(
          path: '/cosigner-search',
          builder: (BuildContext context, GoRouterState state) {
            return Scaffold(
              body: FilledButton(
                key: const Key('select-test-cosigner'),
                onPressed: () => Navigator.of(context).pop(_selectedCosigner),
                child: const Text('Seleccionar aval de prueba'),
              ),
            );
          },
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );

    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.tap(find.byKey(const Key('search-cosigner-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('select-test-cosigner')));
    await tester.pumpAndSettle();

    expect(find.text('Datos del aval'), findsOneWidget);
    final List<String> fieldValues = tester
        .widgetList<TextFormField>(find.byType(TextFormField))
        .map((TextFormField field) => field.controller?.text ?? '')
        .toList();
    expect(fieldValues, containsAll(<String>[
      'FLORES ',
      'AVIÑA',
      'TERESA',
      '12/12/1964',
      'LEONA VICARIO',
      'S/N',
      'CUMUATILLO',
      '59170',
      '0',
      'FOAT641212MMNLVR02',
    ]));
    expect(
      tester.widget<StateDropdown>(find.byType(StateDropdown)).controller.text,
      '16',
    );
    expect(
      tester.widget<CityDropdown>(find.byType(CityDropdown)).controller.text,
      '103',
    );
  });

  testWidgets('loads renewal balance and calculates the amount to deliver',
      (WidgetTester tester) async {
    int? receivedCustomerId;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: NewCreditPage(
              applicationType: NewCreditPage.renewalType,
              initialClient: _selectedCosigner,
              lookupLoanBalance: ({required int customerId}) async {
                receivedCustomerId = customerId;
                return 1250.50;
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(receivedCustomerId, 11);
    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.tap(find.text('Siguiente'));
    await tester.pump();

    final TextFormField outstandingAmountField = tester.widget<TextFormField>(
      find.byKey(const Key('outstanding-amount-field')),
    );
    expect(outstandingAmountField.controller!.text, '1,250.50');

    await tester.enterText(
      find.byKey(const Key('currency-amount-field')),
      '5000',
    );
    await tester.pump();

    final TextFormField amountToDeliverField = tester.widget<TextFormField>(
      find.byKey(const Key('amount-to-deliver-field')),
    );
    expect(amountToDeliverField.controller!.text, '3,749.50');
    expect(outstandingAmountField.readOnly, isTrue);
    expect(amountToDeliverField.readOnly, isTrue);
  });

  testWidgets('returns renewal and reentry applications to their search',
      (WidgetTester tester) async {
    await _expectReturnToSearch(
      tester: tester,
      applicationType: NewCreditPage.renewalType,
      searchPath: '/renewal',
      destinationLabel: 'Búsqueda de renovación',
    );
    await _expectReturnToSearch(
      tester: tester,
      applicationType: NewCreditPage.reentryType,
      searchPath: '/reentry',
      destinationLabel: 'Búsqueda de reingreso',
    );
  });
}

Future<List<RelationshipOption>> _lookupRelationships() async {
  return const <RelationshipOption>[
    RelationshipOption(value: '1', description: 'Esposo (a)'),
    RelationshipOption(value: '4', description: 'Hijo (a)'),
  ];
}

final CustomerLookupResult _selectedCosigner = CustomerLookupResult(
  id: 11,
  lastname: 'FLORES ',
  surname: 'AVIÑA',
  name: 'TERESA',
  birthDate: DateTime.utc(1964, 12, 12),
  street: 'LEONA VICARIO',
  betweenStreets: '',
  extNum: 'S/N',
  intNum: '',
  suburb: 'CUMUATILLO',
  city: 103,
  state: 16,
  zipCode: '59170',
  phoneNumber: null,
  maritalStatus: 0,
  curp: 'FOAT641212MMNLVR02',
);

Future<void> _expectReturnToSearch({
  required WidgetTester tester,
  required int applicationType,
  required String searchPath,
  required String destinationLabel,
}) async {
  final GoRouter router = GoRouter(
    initialLocation: '/new-credit',
    routes: <RouteBase>[
      GoRoute(
        path: '/new-credit',
        builder: (BuildContext context, GoRouterState state) {
          return NewCreditPage(applicationType: applicationType);
        },
      ),
      GoRoute(
        path: searchPath,
        builder: (BuildContext context, GoRouterState state) {
          return Text(destinationLabel);
        },
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(child: MaterialApp.router(routerConfig: router)),
  );

  expect(find.byKey(const Key('return-to-search-button')), findsOneWidget);
  await tester.tap(find.byKey(const Key('return-to-search-button')));
  await tester.pumpAndSettle();

  expect(find.text(destinationLabel), findsOneWidget);
  router.dispose();
}
