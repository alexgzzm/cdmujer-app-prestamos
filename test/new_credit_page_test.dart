import 'package:cdmujer_app_prestamos/features/new_credit/presentation/pages/cosigner_search_page.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/pages/new_credit_page.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/credit_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('runs INE OCR only for a new credit application', () {
    expect(
      NewCreditPage.shouldRunIneOcrFor(NewCreditPage.newCreditType),
      isTrue,
    );
    expect(NewCreditPage.shouldRunIneOcrFor(2), isFalse);
    expect(NewCreditPage.shouldRunIneOcrFor(3), isFalse);
  });

  testWidgets('moves through the new credit wizard',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: NewCreditPage())),
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
    await tester.pump();
    expect(find.text('Información del crédito'), findsOneWidget);
    expect(find.byKey(const Key('proof-attachment-button')), findsOneWidget);
    expect(find.text('Comprobante'), findsOneWidget);
    expect(find.text('Plazo'), findsOneWidget);
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
