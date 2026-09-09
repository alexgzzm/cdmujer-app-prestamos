import 'dart:async';
import 'dart:convert';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_route_option_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/routes_exception.dart';
import 'package:http/http.dart' as http;

class LoanRouteRemoteDataSource {
  LoanRouteRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<List<LoanRouteOptionModel>> getRoutes({required String token}) async {
    try {
      final http.Response response = await _client
          .get(
            ApiConfig.routesEndpoint,
            headers: <String, String>{
              'accept': '*/*',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 45));
      final dynamic responseBody = response.body.isEmpty
          ? null
          : jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw RoutesException(_messageFrom(responseBody));
      }
      if (responseBody is! List<dynamic>) {
        throw const RoutesException('La respuesta de rutas no es válida.');
      }

      return responseBody
          .map((dynamic item) {
            if (item is! Map<String, dynamic>) {
              throw const FormatException('La respuesta de rutas no es válida.');
            }
            return LoanRouteOptionModel.fromJson(item);
          })
          .toList();
    } on RoutesException {
      rethrow;
    } on TimeoutException {
      throw const RoutesException(
        'El servicio de rutas tardó demasiado en responder.',
      );
    } on FormatException {
      throw const RoutesException('La respuesta de rutas no es válida.');
    } on http.ClientException {
      throw const RoutesException(
        'No fue posible conectar con el servicio de rutas.',
      );
    }
  }

  String _messageFrom(dynamic responseBody) {
    if (responseBody is Map<String, dynamic>) {
      final dynamic message = responseBody['message'] ??
          responseBody['error'] ??
          responseBody['detail'] ??
          responseBody['title'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
    }
    return 'No fue posible cargar las rutas.';
  }
}
