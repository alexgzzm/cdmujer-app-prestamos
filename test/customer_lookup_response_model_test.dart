import 'package:cdmujer_app_prestamos/features/loan_search/data/models/customer_lookup_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps the customer response and builds the confirmation name', () {
    final customer = CustomerLookupResponseModel.fromJson(
      _customerJson(),
    ).toEntity();

    expect(customer.id, 84542);
    expect(customer.phoneNumber, isNull);
    expect(customer.birthDate, DateTime.utc(1998, 4, 1));
    expect(customer.fullName, 'MAYRA LIZET, ALVAREZ, TOLENTINO');
  });
}

Map<String, dynamic> _customerJson() {
  return <String, dynamic>{
    'id': 84542,
    'lastname': 'ALVAREZ',
    'surname': 'TOLENTINO',
    'name': 'MAYRA LIZET',
    'birthDate': '1998-04-01T00:00:00',
    'gender': 0,
    'street': 'ART 123',
    'betweenStreets': '',
    'extNum': 'SN',
    'intNum': '',
    'suburb': 'TANACO',
    'city': 24,
    'state': 16,
    'zipCode': '60271',
    'phoneNumber': null,
    'maritalStatus': 0,
    'curp': 'AATM980401MMNLLY05',
  };
}
