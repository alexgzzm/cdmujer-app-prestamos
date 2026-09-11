import 'dart:async';
import 'dart:convert';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_balance_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/loan_balance_exception.dart';
import 'package:http/http.dart' as http;

class LoanBalanceRemoteDataSource {
  LoanBalanceRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<LoanBalanceModel> getBalance({
    required int customerId,
    required String token,
  }) async {
    try {
      final Uri endpoint = ApiConfig.loanBalanceEndpoint.replace(
        queryParameters: <String, String>{
          'idCustomer': customerId.toString(),
        },
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
      if (response.statusCode != 200) {
        throw LoanBalanceException(_messageFrom(responseBody));
      }
      if (responseBody is! Map<String, dynamic>) {
        throw const LoanBalanceException(
          'La respuesta del saldo del cliente no es válida.',
        );
      }
      return LoanBalanceModel.fromJson(responseBody);
    } on LoanBalanceException {
      rethrow;
    } on TimeoutException {
      throw const LoanBalanceException(
        'El servicio tardó demasiado en consultar el saldo del cliente.',
      );
    } on FormatException {
      throw const LoanBalanceException(
        'La respuesta del saldo del cliente no es válida.',
      );
    } on http.ClientException {
      throw const LoanBalanceException(
        'No fue posible conectar con el servicio de saldos.',
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
    return 'No fue posible consultar el saldo del cliente.';
  }
}
