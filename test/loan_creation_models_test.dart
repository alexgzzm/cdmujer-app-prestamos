import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_creation_request_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_creation_response_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_creation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializes the complete loan creation contract', () {
    final Map<String, dynamic> json =
        LoanCreationRequestModel(_sampleLoan()).toJson();

    expect(json['id'], 0);
    expect(json['idRoute'], 122);
    expect(json['idGroup'], 1302);
    expect(json['ammount'], 12500.50);
    expect(json['term'], 14);
    expect(json['date'], '2026-09-09T00:00:00.000Z');
    expect(json['firstPaymentDate'], '2026-10-09T00:00:00.000Z');
    expect(json, isNot(contains('paymentMethod')));
    expect(json, isNot(contains('globalInterest')));
    expect(json, isNot(contains('iva')));
    expect(json, isNot(contains('insurance')));
    expect(json['attachments'], <int>[11, 12]);
    expect((json['client'] as Map<String, dynamic>)['id'], 84542);
    expect(
      (json['client'] as Map<String, dynamic>)['birthDate'],
      '1990-05-20T00:00:00.000Z',
    );
    expect(json['client'] as Map<String, dynamic>, isNot(contains('gender')));
    expect(
      json['client'] as Map<String, dynamic>,
      isNot(contains('client')),
    );
    expect(
      json['client'] as Map<String, dynamic>,
      isNot(contains('rfc')),
    );
    expect(
      json['client'] as Map<String, dynamic>,
      isNot(contains('ine')),
    );
    expect((json['cosigner'] as Map<String, dynamic>)['city'], 19001);
    expect(
      (json['cosigner'] as Map<String, dynamic>)['birthDate'],
      '1990-05-20T00:00:00.000Z',
    );
    expect(
      json['cosigner'] as Map<String, dynamic>,
      isNot(contains('gender')),
    );
  });

  test('maps the generated loan number from a successful response', () {
    final LoanCreationResult result = LoanCreationResponseModel.fromJson(
      <String, dynamic>{
        'id': 20763,
        'status': true,
        'message': 'Prestamo creado exitosamente',
        'messageType': 'Success',
      },
    ).toEntity();

    expect(result.id, 20763);
    expect(result.status, isTrue);
  });
}

LoanCreationData _sampleLoan() {
  final LoanPersonData person = LoanPersonData(
    id: 84542,
    lastname: 'García',
    surname: 'Méndez',
    name: 'María',
    birthDate: DateTime.utc(1990, 5, 20),
    street: 'Reforma',
    betweenStreets: 'Juárez y Morelos',
    extNum: '10',
    intNum: '',
    suburb: 'Centro',
    city: 19001,
    state: 19,
    zipCode: '64000',
    phoneNumber: '5555555555',
    maritalStatus: 1,
    curp: 'GAMG700626MMNLRL04',
  );
  return LoanCreationData(
    idRoute: 122,
    idGroup: 1302,
    client: person,
    cosigner: person,
    date: DateTime.utc(2026, 9, 9),
    ammount: 12500.50,
    term: 14,
    firstPaymentDate: DateTime.utc(2026, 10, 9),
    beneficiary: 'Beneficiario',
    relationship: 'Hijo',
    comments: 'Sin comentarios',
    attachments: const <int>[11, 12],
  );
}
