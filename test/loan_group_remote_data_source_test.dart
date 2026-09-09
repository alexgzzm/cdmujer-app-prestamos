import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_group_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('requests groups for the selected route', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.url.path, '/api/Groups');
      expect(request.url.queryParameters['idRoute'], '122');
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response(
        '[{"value":"1302","description":"CACAHUATAN"}]',
        200,
      );
    });
    final LoanGroupRemoteDataSource dataSource =
        LoanGroupRemoteDataSource(client: client);

    final groups = await dataSource.getGroups(
      routeId: '122',
      token: 'session-token',
    );

    expect(groups, hasLength(1));
    expect(groups.single.value, '1302');
    expect(groups.single.description, 'CACAHUATAN');
  });
}
