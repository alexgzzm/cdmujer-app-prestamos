import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/marital_status_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/marital_status_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selects the marital status value from the catalog',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MaritalStatusDropdown(
            controller: controller,
            maritalStatuses: const <MaritalStatusOption>[
              MaritalStatusOption(value: '1', description: 'Soltero (a)'),
              MaritalStatusOption(value: '2', description: 'Casado (a)'),
            ],
            isLoading: false,
            errorMessage: null,
            onRetry: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Casado (a)').last);
    await tester.pumpAndSettle();

    expect(controller.text, '2');
  });
}
