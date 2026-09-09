import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/ine_extracted_data.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/utils/ine_form_populator.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/responsive_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the extracted CURP in the visible form field',
      (WidgetTester tester) async {
    final TextEditingController curpController = TextEditingController();
    addTearDown(curpController.dispose);
    final Map<String, TextEditingController> controllers =
        <String, TextEditingController>{'curp': curpController};

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResponsiveFormFields(
            fields: const <CreditFieldDefinition>[
              CreditFieldDefinition(name: 'curp', label: 'CURP'),
            ],
            controllers: controllers,
          ),
        ),
      ),
    );

    IneFormPopulator.apply(
      data: const IneExtractedData(curp: 'GOME940127HNLNRRO9'),
      controllers: controllers,
    );
    await tester.pump();

    expect(curpController.text, 'GOME940127HNLNRRO9');
    expect(find.text('GOME940127HNLNRRO9'), findsOneWidget);
  });
}
