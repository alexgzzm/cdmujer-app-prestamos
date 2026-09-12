import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/relationship_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/relationship_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selects the relationship value from the catalog',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RelationshipDropdown(
            controller: controller,
            relationships: const <RelationshipOption>[
              RelationshipOption(value: '1', description: 'Esposo (a)'),
              RelationshipOption(value: '4', description: 'Hijo (a)'),
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
    await tester.tap(find.text('Hijo (a)').last);
    await tester.pumpAndSettle();

    expect(controller.text, '4');
  });
}
