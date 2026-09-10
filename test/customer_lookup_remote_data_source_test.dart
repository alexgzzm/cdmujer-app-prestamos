import 'package:cdmujer_app_prestamos/features/loan_search/data/datasources/customer_lookup_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('searches a customer by loan number and sends the bearer token',
      () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'GET');
      expect(
        request.url.path,
        '/api/Customers/GetCustomerFromLoanOrCurp',
      );
      expect(request.url.queryParameters['loanNumber'], '15');
      expect(request.url.queryParameters['curp'], '');
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response(_responseBody, 200);
    });

    final response = await CustomerLookupRemoteDataSource(client: client).search(
      loanNumber: '15',
      curp: '',
      token: 'session-token',
    );

    expect(response.customer.id, 84542);
    expect(response.customer.curp, 'AATM980401MMNLLY05');
  });
}

const String _responseBody = '''
{
  "id": 84542,
  "lastname": "ALVAREZ",
  "surname": "TOLENTINO",
  "name": "MAYRA LIZET",
  "gender": 0,
  "street": "ART 123",
  "betweenStreets": "",
  "extNum": "SN",
  "intNum": "",
  "suburb": "TANACO",
  "city": 24,
  "state": 16,
  "zipCode": "60271",
  "phoneNumber": null,
  "maritalStatus": 0,
  "curp": "AATM980401MMNLLY05"
}
''';
