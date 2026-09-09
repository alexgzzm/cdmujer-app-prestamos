import 'dart:async';
import 'dart:convert';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_group_option_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/groups_exception.dart';
import 'package:http/http.dart' as http;

class LoanGroupRemoteDataSource {
  LoanGroupRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<List<LoanGroupOptionModel>> getGroups({
    required String routeId,
    required String token,
  }) async {
    try {
      final Uri endpoint = ApiConfig.groupsEndpoint.replace(
        queryParameters: <String, String>{'idRoute': routeId},
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
        throw GroupsException(_messageFrom(responseBody));
      }
      if (responseBody is! List<dynamic>) {
        throw const GroupsException('La respuesta de grupos no es válida.');
      }

      return responseBody.map((dynamic item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('La respuesta de grupos no es válida.');
        }
        return LoanGroupOptionModel.fromJson(item);
      }).toList();
    } on GroupsException {
      rethrow;
    } on TimeoutException {
      throw const GroupsException(
        'El servicio de grupos tardó demasiado en responder.',
      );
    } on FormatException {
      throw const GroupsException('La respuesta de grupos no es válida.');
    } on http.ClientException {
      throw const GroupsException(
        'No fue posible conectar con el servicio de grupos.',
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
    return 'No fue posible cargar los grupos.';
  }
}
