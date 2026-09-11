import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_balance_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('gets the customer balance and sends the bearer token', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/Loans/GetBalance');
      expect(request.url.queryParameters, <String, String>{
        'idCustomer': '23780',
      });
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response('{"amount": 1250.50}', 200);
    });

    final result = await LoanBalanceRemoteDataSource(client: client).getBalance(
      customerId: 23780,
      token: 'session-token',
    );

    expect(result.amount, 1250.50);
    expect(result.toEntity().amount, 1250.50);
  });
}
