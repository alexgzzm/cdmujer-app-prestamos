import 'dart:async';
import 'dart:convert';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/city_option_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/cities_exception.dart';
import 'package:http/http.dart' as http;

class CityRemoteDataSource {
  CityRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<List<CityOptionModel>> getCities({
    required String stateId,
    required String token,
  }) async {
    try {
      final Uri endpoint = ApiConfig.citiesEndpoint.replace(
        queryParameters: <String, String>{'stateId': stateId},
      );
      final http.Response response = await _client
          .get(
            endpoint,
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
        throw CitiesException(_messageFrom(responseBody));
      }
      if (responseBody is! List<dynamic>) {
        throw const CitiesException('La respuesta de municipios no es válida.');
      }

      return responseBody.map((dynamic item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('La respuesta de municipios no es válida.');
        }
        return CityOptionModel.fromJson(item);
      }).toList();
    } on CitiesException {
      rethrow;
    } on TimeoutException {
      throw const CitiesException(
        'El servicio de municipios tardó demasiado en responder.',
      );
    } on FormatException {
      throw const CitiesException('La respuesta de municipios no es válida.');
    } on http.ClientException {
      throw const CitiesException(
        'No fue posible conectar con el servicio de municipios.',
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
    return 'No fue posible cargar los municipios.';
  }
}
