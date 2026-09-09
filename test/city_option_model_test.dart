import 'package:cdmujer_app_prestamos/features/new_credit/data/models/city_option_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps the city API response item', () {
    final CityOptionModel model = CityOptionModel.fromJson(
      <String, dynamic>{'value': '19001', 'description': 'Monterrey'},
    );

    final city = model.toEntity();
    expect(city.value, '19001');
    expect(city.description, 'Monterrey');
  });
}
