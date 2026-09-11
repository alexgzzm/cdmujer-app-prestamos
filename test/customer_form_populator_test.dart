import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/utils/customer_form_populator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('prefills only the client controllers', () {
    final Map<String, TextEditingController> client = _controllers();
    final Map<String, TextEditingController> cosigner = _controllers();
    final Map<String, TextEditingController> credit =
        <String, TextEditingController>{'term': TextEditingController()};
    addTearDown(() {
      for (final controller in <TextEditingController>[
        ...client.values,
        ...cosigner.values,
        ...credit.values,
      ]) {
        controller.dispose();
      }
    });

    CustomerFormPopulator.apply(
      customer: _customer,
      controllers: client,
    );

    expect(client['name']!.text, 'MAYRA LIZET');
    expect(client['birthDate']!.text, '01/04/1998');
    expect(client['state']!.text, '16');
    expect(client['city']!.text, '24');
    expect(client['phoneNumber']!.text, '');
    expect(client['curp']!.text, 'AATM980401MMNLLY05');
    expect(
      cosigner.values.every((controller) => controller.text.isEmpty),
      isTrue,
    );
    expect(credit['term']!.text, isEmpty);
  });
}

Map<String, TextEditingController> _controllers() {
  return <String, TextEditingController>{
    for (final String name in <String>[
      'lastname',
      'surname',
      'name',
      'birthDate',
      'street',
      'betweenStreets',
      'extNum',
      'intNum',
      'suburb',
      'city',
      'state',
      'zipCode',
      'phoneNumber',
      'maritalStatus',
      'curp',
    ])
      name: TextEditingController(),
  };
}

final CustomerLookupResult _customer = CustomerLookupResult(
  id: 84542,
  lastname: 'ALVAREZ',
  surname: 'TOLENTINO',
  name: 'MAYRA LIZET',
  birthDate: DateTime.utc(1998, 4, 1),
  street: 'ART 123',
  betweenStreets: '',
  extNum: 'SN',
  intNum: '',
  suburb: 'TANACO',
  city: 24,
  state: 16,
  zipCode: '60271',
  phoneNumber: null,
  maritalStatus: 0,
  curp: 'AATM980401MMNLLY05',
);
