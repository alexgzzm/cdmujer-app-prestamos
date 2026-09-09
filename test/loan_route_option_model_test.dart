import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_route_option_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps the route API response item', () {
    final LoanRouteOptionModel model = LoanRouteOptionModel.fromJson(
      <String, dynamic>{
        'value': '122',
        'description': 'R4 TAPACHULA',
      },
    );

    final route = model.toEntity();
    expect(route.value, '122');
    expect(route.description, 'R4 TAPACHULA');
  });
}
