import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/relationship_remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('requests and maps the relationship catalog', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/Catalogs/GetRelationships');
      expect(request.headers['Authorization'], 'Bearer session-token');
      return http.Response(
        '[{"value":"1","description":"Esposo (a)"},'
        '{"value":"4","description":"Hijo (a)"}]',
        200,
      );
    });
    final RelationshipRemoteDataSource dataSource =
        RelationshipRemoteDataSource(client: client);

    final relationships = await dataSource.getRelationships(
      token: 'session-token',
    );

    expect(relationships, hasLength(2));
    expect(relationships.first.value, '1');
    expect(relationships.last.description, 'Hijo (a)');
  });
}
