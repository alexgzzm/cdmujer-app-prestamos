import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/responsive_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('limits postal codes to five digits while preserving leading zeroes',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResponsiveFormFields(
            fields: <CreditFieldDefinition>[
              CreditFieldDefinition(
                name: 'zipCode',
                label: 'Código postal',
                keyboardType: TextInputType.number,
                maxLength: 5,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ],
            controllers: <String, TextEditingController>{
              'zipCode': controller,
            },
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), '04253abc9');

    expect(controller.text, '04253');
  });
}
