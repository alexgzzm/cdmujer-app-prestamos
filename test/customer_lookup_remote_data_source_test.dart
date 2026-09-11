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
    expect(response.customer.birthDate, DateTime.utc(1998, 4, 1));
  });

  test('searches customers by full name and sends the bearer token', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'GET');
      expect(
        request.url.path,
        '/api/Customers/SearchCustomersByName',
      );
      expect(request.url.queryParameters, <String, String>{
        'name': 'TERESA',
        'lastname': 'FLORES',
        'surname': 'AVIÑA',
      });
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response(_nameSearchResponseBody, 200);
    });

    final response =
        await CustomerLookupRemoteDataSource(client: client).searchByName(
      name: 'TERESA',
      lastname: 'FLORES',
      surname: 'AVIÑA',
      token: 'session-token',
    );

    expect(response, hasLength(1));
    expect(response.single.customer.name, 'TERESA FLORES AVIÑA');
    expect(response.single.customer.curp, 'FOAT641212MMNLVR02');
  });

  test('gets the selected cosigner by id and sends the bearer token', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/Customers/GetById');
      expect(request.url.queryParameters, <String, String>{
        'idCustomer': '11',
      });
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response(_cosignerResponseBody, 200);
    });

    final response =
        await CustomerLookupRemoteDataSource(client: client).getById(
      customerId: 11,
      token: 'session-token',
    );

    expect(response.customer.id, 11);
    expect(response.customer.lastname, 'FLORES ');
    expect(response.customer.surname, 'AVIÑA');
    expect(response.customer.name, 'TERESA');
    expect(response.customer.state, 16);
    expect(response.customer.city, 103);
    expect(response.customer.phoneNumber, isNull);
    expect(response.customer.birthDate, DateTime.utc(1964, 12, 12));
  });
}

const String _responseBody = '''
{
  "id": 84542,
  "lastname": "ALVAREZ",
  "surname": "TOLENTINO",
  "name": "MAYRA LIZET",
  "birthDate": "1998-04-01T00:00:00",
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

const String _nameSearchResponseBody = '''
[
  {
    "id": 11,
    "name": "TERESA FLORES AVIÑA",
    "curp": "FOAT641212MMNLVR02",
    "lastLoan": "105",
    "loanRoute": "RUTA 1",
    "loanGroup": "GRUPO A"
  }
]
''';

const String _cosignerResponseBody = '''
{
  "id": 11,
  "lastname": "FLORES ",
  "surname": "AVIÑA",
  "name": "TERESA",
  "gender": 0,
  "street": "LEONA VICARIO",
  "betweenStreets": "",
  "extNum": "S/N",
  "intNum": "",
  "suburb": "CUMUATILLO",
  "city": 103,
  "state": 16,
  "zipCode": "59170",
  "phoneNumber": null,
  "maritalStatus": 0,
  "curp": "FOAT641212MMNLVR02",
  "birthDate": "1964-12-12"
}
''';
