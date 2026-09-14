import 'package:cdmujer_app_prestamos/features/new_credit/data/models/marital_status_option_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps the marital status API response item', () {
    final MaritalStatusOptionModel model = MaritalStatusOptionModel.fromJson(
      <String, dynamic>{'value': '1', 'description': 'Soltero (a)'},
    );

    final maritalStatus = model.toEntity();
    expect(maritalStatus.value, '1');
    expect(maritalStatus.description, 'Soltero (a)');
  });
}
