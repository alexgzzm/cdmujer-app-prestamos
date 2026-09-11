import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_information_validation_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('posts a new client CURP with empty loan and customer identifiers',
      () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/Loans/ValidateInformation');
      expect(request.url.queryParameters['curp'], 'GAMG700626MMNLRL04');
      expect(request.url.queryParameters['loanNumber'], '');
      expect(request.url.queryParameters['idCustomer'], '');
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response(
        '{"id":null,"status":true,'
        '"message":"No existen prestamos asociados al RFC",'
        '"messageType":"Success"}',
        200,
      );
    });
    final LoanInformationValidationRemoteDataSource dataSource =
        LoanInformationValidationRemoteDataSource(client: client);

    final validation = await dataSource.validate(
      curp: 'GAMG700626MMNLRL04',
      idCustomer: null,
      token: 'session-token',
    );

    expect(validation.status, isTrue);
  });

  test('posts an existing customer id even when the CURP is empty', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'POST');
      expect(request.url.path, '/api/Loans/ValidateInformation');
      expect(request.url.queryParameters['curp'], '');
      expect(request.url.queryParameters['loanNumber'], '');
      expect(request.url.queryParameters['idCustomer'], '84542');
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response(
        '{"id":84542,"status":true,'
        '"message":"El cliente puede continuar",'
        '"messageType":"Success"}',
        200,
      );
    });
    final LoanInformationValidationRemoteDataSource dataSource =
        LoanInformationValidationRemoteDataSource(client: client);

    final validation = await dataSource.validate(
      curp: '',
      idCustomer: 84542,
      token: 'session-token',
    );

    expect(validation.id, 84542);
    expect(validation.status, isTrue);
  });
}
