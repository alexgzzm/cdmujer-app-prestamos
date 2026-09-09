import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/state_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/state_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps client and cosigner state selections independent',
      (WidgetTester tester) async {
    final TextEditingController clientController = TextEditingController(text: '1');
    final TextEditingController cosignerController = TextEditingController(text: '2');
    addTearDown(clientController.dispose);
    addTearDown(cosignerController.dispose);
    const List<StateOption> states = <StateOption>[
      StateOption(value: '1', description: 'Aguascalientes'),
      StateOption(value: '2', description: 'Baja California'),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              StateDropdown(
                controller: clientController,
                states: states,
                isLoading: false,
                errorMessage: null,
                onRetry: () {},
              ),
              StateDropdown(
                controller: cosignerController,
                states: states,
                isLoading: false,
                errorMessage: null,
                onRetry: () {},
              ),
            ],
          ),
        ),
      ),
    );

    expect(clientController.text, '1');
    expect(cosignerController.text, '2');
    expect(find.text('Aguascalientes'), findsOneWidget);
    expect(find.text('Baja California'), findsOneWidget);
  });
}
