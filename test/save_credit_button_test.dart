import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/save_credit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('cancels or confirms saving without changing form data',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController(text: 'Dato');
    addTearDown(controller.dispose);
    int saveCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              TextField(controller: controller),
              SaveCreditButton(
                isSaving: false,
                onSave: () async {
                  saveCalls++;
                },
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('save-credit-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    expect(saveCalls, 0);
    expect(controller.text, 'Dato');

    await tester.tap(find.byKey(const Key('save-credit-button')));
    await tester.pumpAndSettle();
    final Finder confirmButton = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.widgetWithText(FilledButton, 'Guardar'),
    );
    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    expect(saveCalls, 1);
    expect(controller.text, 'Dato');
  });
}
