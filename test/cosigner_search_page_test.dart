import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_name_match.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/pages/cosigner_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('requires the complete cosigner name before searching',
      (WidgetTester tester) async {
    int lookupCalls = 0;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CosignerSearchPage(
              lookupCustomersByName: ({
                required String name,
                required String lastname,
                required String surname,
              }) async {
                lookupCalls++;
                return const <CustomerNameMatch>[];
              },
            ),
          ),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(3));
    await tester.tap(find.byKey(const Key('cosigner-search-submit-button')));
    await tester.pump();
    expect(find.text('Captura el nombre completo del aval.'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('cosigner-name-field')),
      'Teresa',
    );
    await tester.tap(find.byKey(const Key('cosigner-search-submit-button')));
    await tester.pump();

    expect(
      find.text(
        'Para buscar por nombre, captura nombres, apellido paterno y apellido materno.',
      ),
      findsOneWidget,
    );
    expect(lookupCalls, 0);
  });

  testWidgets('searches by complete name and looks up the selection by id',
      (WidgetTester tester) async {
    String? receivedName;
    String? receivedLastname;
    String? receivedSurname;
    int? receivedCustomerId;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CosignerSearchPage(
              lookupCustomersByName: ({
                required String name,
                required String lastname,
                required String surname,
              }) async {
                receivedName = name;
                receivedLastname = lastname;
                receivedSurname = surname;
                return _matches;
              },
              lookupCustomerById: ({required int customerId}) async {
                receivedCustomerId = customerId;
                return _cosigner;
              },
            ),
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('cosigner-name-field')),
      'teresa',
    );
    await tester.enterText(
      find.byKey(const Key('cosigner-lastname-field')),
      'flores',
    );
    await tester.enterText(
      find.byKey(const Key('cosigner-surname-field')),
      'aviña',
    );
    await tester.tap(find.byKey(const Key('cosigner-search-submit-button')));
    await tester.pumpAndSettle();

    expect(receivedName, 'TERESA');
    expect(receivedLastname, 'FLORES');
    expect(receivedSurname, 'AVIÑA');
    expect(find.byKey(const Key('cosigner-match-11')), findsOneWidget);
    expect(find.text('TERESA FLORES AVIÑA'), findsOneWidget);
    expect(find.text('CURP: FOAT641212MMNLVR02'), findsOneWidget);
    expect(find.text('Último préstamo: 105'), findsOneWidget);
    expect(find.text('Ruta: RUTA 1'), findsOneWidget);
    expect(find.text('Grupo: GRUPO A'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cosigner-match-11')));
    await tester.pump();

    expect(receivedCustomerId, 11);
  });
}

const List<CustomerNameMatch> _matches = <CustomerNameMatch>[
  CustomerNameMatch(
    id: 11,
    name: 'TERESA FLORES AVIÑA',
    curp: 'FOAT641212MMNLVR02',
    lastLoan: '105',
    loanRoute: 'RUTA 1',
    loanGroup: 'GRUPO A',
  ),
];

final CustomerLookupResult _cosigner = CustomerLookupResult(
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
