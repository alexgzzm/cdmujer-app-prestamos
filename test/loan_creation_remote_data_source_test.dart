import 'dart:convert';

import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_creation_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_creation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('posts a loan and returns its generated number', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/Loans');
      expect(request.headers['Authorization'], 'Bearer session-token');
      expect(request.headers['Content-Type'], contains('application/json'));
      final Map<String, dynamic> body =
          jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['idRoute'], 122);
      expect(body['term'], 16);
      return http.Response(
        '{"id":20763,"status":true,'
        '"message":"Prestamo creado exitosamente",'
        '"messageType":"Success"}',
        200,
      );
    });
    final LoanCreationRemoteDataSource dataSource =
        LoanCreationRemoteDataSource(client: client);

    final response = await dataSource.create(
      data: _sampleLoan(),
      token: 'session-token',
    );

    expect(response.id, 20763);
  });
}

LoanCreationData _sampleLoan() {
  const LoanPersonData person = LoanPersonData(
    lastname: 'García',
    surname: 'Méndez',
    name: 'María',
    gender: 2,
    street: 'Reforma',
    betweenStreets: '',
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
    term: 16,
    firstPaymentDate: DateTime.utc(2026, 10, 9),
    beneficiary: '',
    relationship: '',
    comments: '',
    attachments: const <int>[11],
  );
}
