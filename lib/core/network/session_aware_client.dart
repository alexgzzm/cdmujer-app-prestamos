import 'package:http/http.dart' as http;

class SessionAwareClient extends http.BaseClient {
  SessionAwareClient({
    required http.Client inner,
    required void Function(String token) onUnauthorized,
  })  : _inner = inner,
        _onUnauthorized = onUnauthorized;

  final http.Client _inner;
  final void Function(String token) _onUnauthorized;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final http.StreamedResponse response = await _inner.send(request);
    if (response.statusCode == 401) {
      final String? authorization = request.headers['Authorization'];
      if (authorization != null && authorization.startsWith('Bearer ')) {
        _onUnauthorized(authorization.substring('Bearer '.length));
      }
    }
    return response;
  }

  @override
  void close() => _inner.close();
}
