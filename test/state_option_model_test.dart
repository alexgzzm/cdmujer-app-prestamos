import 'package:cdmujer_app_prestamos/features/new_credit/data/models/state_option_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps the state API response item', () {
    final StateOptionModel model = StateOptionModel.fromJson(
      <String, dynamic>{'value': '1', 'description': 'Aguascalientes'},
    );

    final state = model.toEntity();
    expect(state.value, '1');
    expect(state.description, 'Aguascalientes');
  });
}
