import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/credit_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses the displayed date for the API payload', () {
    expect(parseCreditDate('09/09/2026'), DateTime.utc(2026, 9, 9));
    expect(parseCreditDate('31/02/2026'), isNull);
  });

  test('calculates the latest birth date allowed for an adult', () {
    expect(
      latestAdultBirthDate(DateTime.utc(2026, 9, 10)),
      DateTime.utc(2008, 9, 10),
    );
    expect(
      latestAdultBirthDate(DateTime.utc(2024, 2, 29)),
      DateTime.utc(2006, 2, 28),
    );
  });

  testWidgets('writes the selected date in dd/MM/yyyy format',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CreditDatePicker(
            controller: controller,
            label: 'Fecha',
            pickDate: (BuildContext context, DateTime initialDate) async {
              return DateTime(2026, 9, 5);
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('credit-date-picker-Fecha')));
    await tester.pump();

    expect(controller.text, '05/09/2026');
    expect(find.text('05/09/2026'), findsOneWidget);
  });

  testWidgets('starts an empty birth date calendar at the adult limit',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    final DateTime adultLimit = DateTime.utc(2008, 9, 10);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CreditDatePicker(
            controller: controller,
            label: 'Fecha de nacimiento',
            firstDate: DateTime.utc(1900),
            lastDate: adultLimit,
            pickDate: (BuildContext context, DateTime initialDate) async {
              expect(initialDate, adultLimit);
              return null;
            },
          ),
        ),
      ),
    );

    await tester.tap(
      find.byKey(
        const Key('credit-date-picker-Fecha de nacimiento'),
      ),
    );
    await tester.pump();

    expect(controller.text, isEmpty);
  });

  testWidgets('shows the calendar in Spanish', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController(
      text: '05/09/2026',
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('es', 'MX'),
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[Locale('es', 'MX')],
        home: Scaffold(
          body: CreditDatePicker(controller: controller, label: 'Fecha'),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('credit-date-picker-Fecha')));
    await tester.pumpAndSettle();

    expect(find.textContaining('septiembre'), findsWidgets);
  });
}
