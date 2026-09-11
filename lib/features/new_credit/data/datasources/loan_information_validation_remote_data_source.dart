import 'dart:async';
import 'dart:convert';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_information_validation_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/loan_information_validation_exception.dart';
import 'package:http/http.dart' as http;

class LoanInformationValidationRemoteDataSource {
  LoanInformationValidationRemoteDataSource({required http.Client client})
      : _client = client;

  final http.Client _client;

  Future<LoanInformationValidationModel> validate({
    required String curp,
    required int? idCustomer,
    required String token,
  }) async {
    try {
      final Uri endpoint = ApiConfig.validateLoanInformationEndpoint.replace(
        queryParameters: <String, String>{
          'curp': curp,
          'loanNumber': '',
          'idCustomer': idCustomer?.toString() ?? '',
        },
      );
      final http.Response response = await _client
          .post(
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
        throw LoanInformationValidationException(_messageFrom(responseBody));
      }
      if (responseBody is! Map<String, dynamic>) {
        throw const LoanInformationValidationException(
          'La respuesta de validación del CURP no es válida.',
        );
      }
      return LoanInformationValidationModel.fromJson(responseBody);
    } on LoanInformationValidationException {
      rethrow;
    } on TimeoutException {
      throw const LoanInformationValidationException(
        'La validación del CURP tardó demasiado en responder.',
      );
    } on FormatException {
      throw const LoanInformationValidationException(
        'La respuesta de validación del CURP no es válida.',
      );
    } on http.ClientException {
      throw const LoanInformationValidationException(
        'No fue posible conectar con el servicio de validación del CURP.',
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
    return 'No fue posible validar la información del CURP.';
  }
}
