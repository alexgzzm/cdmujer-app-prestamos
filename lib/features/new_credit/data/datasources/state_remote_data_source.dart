import 'dart:async';
import 'dart:convert';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/state_option_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/states_exception.dart';
import 'package:http/http.dart' as http;

class StateRemoteDataSource {
  StateRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<List<StateOptionModel>> getStates({required String token}) async {
    try {
      final http.Response response = await _client
          .get(
            ApiConfig.statesEndpoint,
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
        throw StatesException(_messageFrom(responseBody));
      }
      if (responseBody is! List<dynamic>) {
        throw const StatesException('La respuesta de estados no es válida.');
      }

      return responseBody.map((dynamic item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('La respuesta de estados no es válida.');
        }
        return StateOptionModel.fromJson(item);
      }).toList();
    } on StatesException {
      rethrow;
    } on TimeoutException {
      throw const StatesException(
        'El servicio de estados tardó demasiado en responder.',
      );
    } on FormatException {
      throw const StatesException('La respuesta de estados no es válida.');
    } on http.ClientException {
      throw const StatesException(
        'No fue posible conectar con el servicio de estados.',
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
    return 'No fue posible cargar los estados.';
  }
}
