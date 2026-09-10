import 'package:cdmujer_app_prestamos/features/loan_search/data/models/customer_name_match_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps and serializes a customer name match', () {
    final CustomerNameMatchModel model = CustomerNameMatchModel.fromJson(
      <String, dynamic>{
        'id': 11,
        'name': 'TERESA FLORES AVIÑA',
        'curp': 'FOAT641212MMNLVR02',
        'lastLoan': '105',
        'loanRoute': 'RUTA 1',
        'loanGroup': 'GRUPO A',
      },
    );

    expect(model.customer.id, 11);
    expect(model.customer.name, 'TERESA FLORES AVIÑA');
    expect(model.customer.hasLoanInformation, isTrue);
    expect(model.toJson(), <String, dynamic>{
      'id': 11,
      'name': 'TERESA FLORES AVIÑA',
      'curp': 'FOAT641212MMNLVR02',
      'lastLoan': '105',
      'loanRoute': 'RUTA 1',
      'loanGroup': 'GRUPO A',
    });
  });

  test('identifies matches without previous loan information', () {
    final model = CustomerNameMatchModel.fromJson(<String, dynamic>{
      'id': 11,
      'name': 'TERESA FLORES AVIÑA',
      'curp': 'FOAT641212MMNLVR02',
      'lastLoan': null,
      'loanRoute': null,
      'loanGroup': null,
    });

    expect(model.customer.hasLoanInformation, isFalse);
    expect(model.customer.lastLoan, isEmpty);
  });
}
