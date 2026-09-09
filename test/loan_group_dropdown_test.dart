import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_group_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/loan_group_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps one menu item for a duplicated group ID',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController(text: '1537');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LoanGroupDropdown(
            controller: controller,
            groups: const <LoanGroupOption>[
              LoanGroupOption(value: '1537', description: 'Grupo A'),
              LoanGroupOption(value: '1537', description: 'Grupo A repetido'),
            ],
            isLoading: false,
            errorMessage: null,
            isRouteSelected: true,
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
  });
}
