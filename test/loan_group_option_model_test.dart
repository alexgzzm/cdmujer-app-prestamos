import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_group_option_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps the group API response item', () {
    final LoanGroupOptionModel model = LoanGroupOptionModel.fromJson(
      <String, dynamic>{
        'value': '1302',
        'description': 'CACAHUATAN',
      },
    );

    final group = model.toEntity();
    expect(group.value, '1302');
    expect(group.description, 'CACAHUATAN');
  });
}
