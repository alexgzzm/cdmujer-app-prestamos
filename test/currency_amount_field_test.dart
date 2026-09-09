import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/currency_amount_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats thousands while preserving a decimal value', () {
    expect(formatCurrencyInput('1234567.89'), '1,234,567.89');
    expect(normalizeCurrencyInput('1,234,567.89'), '1234567.89');
    expect(normalizeCurrencyInput('.50'), '0.50');
  });

  testWidgets('shows currency formatting and reports a decimal amount',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);
    String decimalAmount = '';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CurrencyAmountField(
            controller: controller,
            onDecimalChanged: (String value) => decimalAmount = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byKey(const Key('currency-amount-field')), '1234.50');
    await tester.pump();

    expect(controller.text, '1,234.50');
    expect(decimalAmount, '1234.50');
    expect(find.byIcon(Icons.attach_money), findsOneWidget);
  });
}
