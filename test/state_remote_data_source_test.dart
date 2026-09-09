import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/state_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('requests the states catalog with the session token', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.url.path, '/api/Locations/GetStates');
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response(
        '[{"value":"1","description":"Aguascalientes"}]',
        200,
      );
    });
    final StateRemoteDataSource dataSource = StateRemoteDataSource(client: client);

    final states = await dataSource.getStates(token: 'session-token');

    expect(states, hasLength(1));
    expect(states.single.value, '1');
  });
}
