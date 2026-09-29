import 'package:cdmujer_app_prestamos/core/network/session_aware_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('SessionAwareClient', () {
    test('reports a 401 for an authenticated request', () async {
      final List<String> expiredTokens = <String>[];
      final SessionAwareClient client = SessionAwareClient(
        inner:
            MockClient((http.Request request) async => http.Response('', 401)),
        onUnauthorized: expiredTokens.add,
      );

      final http.Response response = await client.get(
        Uri.parse('https://example.com/api/states'),
        headers: <String, String>{'Authorization': 'Bearer expired-token'},
      );

      expect(response.statusCode, 401);
      expect(expiredTokens, <String>['expired-token']);
      client.close();
    });

    test('does not expire the session for login or other errors', () async {
      final List<String> expiredTokens = <String>[];
      final SessionAwareClient client = SessionAwareClient(
        inner: MockClient((http.Request request) async => http.Response(
            '', request.headers.containsKey('Authorization') ? 500 : 401)),
        onUnauthorized: expiredTokens.add,
      );

      await client.post(Uri.parse('https://example.com/api/auth'));
      await client.get(
        Uri.parse('https://example.com/api/states'),
        headers: <String, String>{'Authorization': 'Bearer valid-token'},
      );

      expect(expiredTokens, isEmpty);
      client.close();
    });
  });
}
