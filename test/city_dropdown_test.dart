import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/city_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/city_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows a city only after its state is selected',
      (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController(text: '19001');
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CityDropdown(
            controller: controller,
            cities: const <CityOption>[
              CityOption(value: '19001', description: 'Monterrey'),
            ],
            isLoading: false,
            errorMessage: null,
            isStateSelected: true,
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.text('Monterrey'), findsOneWidget);
  });
}
