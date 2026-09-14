import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/marital_status_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('requests and maps the marital status catalog', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/Catalogs/GetMaritalStatus');
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response(
        '[{"value":"1","description":"Soltero (a)"},'
        '{"value":"2","description":"Casado (a)"}]',
        200,
      );
    });
    final MaritalStatusRemoteDataSource dataSource =
        MaritalStatusRemoteDataSource(client: client);

    final maritalStatuses = await dataSource.getMaritalStatuses(
      token: 'session-token',
    );

    expect(maritalStatuses, hasLength(2));
    expect(maritalStatuses.first.value, '1');
    expect(maritalStatuses.last.description, 'Casado (a)');
  });
}
