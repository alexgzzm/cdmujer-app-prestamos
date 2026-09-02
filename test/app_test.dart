import 'package:cdmujer_app_prestamos/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the home modules', (WidgetTester tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Préstamos'), findsOneWidget);
    expect(find.text('Pagos'), findsOneWidget);
  });
}
