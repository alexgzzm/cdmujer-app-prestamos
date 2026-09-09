import 'dart:async';
import 'dart:convert';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_creation_request_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_creation_response_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_creation.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/loan_creation_exception.dart';
import 'package:http/http.dart' as http;

class LoanCreationRemoteDataSource {
  LoanCreationRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<LoanCreationResponseModel> create({
    required LoanCreationData data,
    required String token,
  }) async {
    try {
      final http.Response response = await _client
          .post(
            ApiConfig.loansEndpoint,
            headers: <String, String>{
              'accept': '*/*',
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(LoanCreationRequestModel(data).toJson()),
          )
          .timeout(const Duration(seconds: 45));
      final dynamic responseBody = response.body.isEmpty
          ? null
          : jsonDecode(response.body);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw LoanCreationException(_messageFrom(responseBody));
      }
      if (responseBody is! Map<String, dynamic>) {
        throw const LoanCreationException(
          'La respuesta de creación del crédito no es válida.',
        );
      }
      return LoanCreationResponseModel.fromJson(responseBody);
    } on LoanCreationException {
      rethrow;
    } on TimeoutException {
      throw const LoanCreationException(
        'El servicio tardó demasiado en guardar el crédito.',
      );
    } on FormatException {
      throw const LoanCreationException(
        'La respuesta de creación del crédito no es válida.',
      );
    } on http.ClientException {
      throw const LoanCreationException(
        'No fue posible conectar con el servicio de créditos.',
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
    return 'No fue posible guardar el crédito.';
  }
}
