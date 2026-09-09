import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/city_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('requests cities for the selected state', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.url.path, '/api/Locations/GetCities');
      expect(request.url.queryParameters['stateId'], '19');
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response(
        '[{"value":"19001","description":"Monterrey"}]',
        200,
      );
    });
    final CityRemoteDataSource dataSource = CityRemoteDataSource(client: client);

    final cities = await dataSource.getCities(
      stateId: '19',
      token: 'session-token',
    );

    expect(cities, hasLength(1));
    expect(cities.single.value, '19001');
  });
}
