import 'dart:async';
import 'dart:convert';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/data/models/customer_lookup_response_model.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/data/models/customer_name_match_model.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/errors/customer_lookup_exception.dart';
import 'package:http/http.dart' as http;

class CustomerLookupRemoteDataSource {
  CustomerLookupRemoteDataSource({required http.Client client})
      : _client = client;

  final http.Client _client;

  Future<CustomerLookupResponseModel> search({
    required String loanNumber,
    required String curp,
    required String token,
  }) async {
    try {
      final Uri endpoint = ApiConfig.customerFromLoanOrCurpEndpoint.replace(
        queryParameters: <String, String>{
          'loanNumber': loanNumber,
          'curp': curp,
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
        throw CustomerLookupException(_messageFrom(responseBody));
      }
      if (responseBody is! Map<String, dynamic>) {
        throw const CustomerLookupException(
          'La respuesta de búsqueda del cliente no es válida.',
        );
      }
      return CustomerLookupResponseModel.fromJson(responseBody);
    } on CustomerLookupException {
      rethrow;
    } on TimeoutException {
      throw const CustomerLookupException(
        'El servicio tardó demasiado en buscar al cliente.',
      );
    } on FormatException {
      throw const CustomerLookupException(
        'La respuesta de búsqueda del cliente no es válida.',
      );
    } on http.ClientException {
      throw const CustomerLookupException(
        'No fue posible conectar con el servicio de clientes.',
      );
    }
  }

  Future<List<CustomerNameMatchModel>> searchByName({
    required String name,
    required String lastname,
    required String surname,
    required String token,
  }) async {
    try {
      final Uri endpoint = ApiConfig.customersByNameEndpoint.replace(
        queryParameters: <String, String>{
          'name': name,
          'lastname': lastname,
          'surname': surname,
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
        throw CustomerLookupException(_messageFrom(responseBody));
      }
      if (responseBody is! List<dynamic>) {
        throw const CustomerLookupException(
          'La respuesta de búsqueda de clientes no es válida.',
        );
      }
      return responseBody.map<CustomerNameMatchModel>((dynamic item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException(
            'La respuesta de búsqueda de clientes no es válida.',
          );
        }
        return CustomerNameMatchModel.fromJson(item);
      }).toList();
    } on CustomerLookupException {
      rethrow;
    } on TimeoutException {
      throw const CustomerLookupException(
        'El servicio tardó demasiado en buscar clientes.',
      );
    } on FormatException {
      throw const CustomerLookupException(
        'La respuesta de búsqueda de clientes no es válida.',
      );
    } on http.ClientException {
      throw const CustomerLookupException(
        'No fue posible conectar con el servicio de clientes.',
      );
    }
  }

  Future<CustomerLookupResponseModel> getById({
    required int customerId,
    required String token,
  }) async {
    try {
      final Uri endpoint = ApiConfig.customerByIdEndpoint.replace(
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
        throw CustomerLookupException(_messageFrom(responseBody));
      }
      if (responseBody is! Map<String, dynamic>) {
        throw const CustomerLookupException(
          'La respuesta de consulta del aval no es válida.',
        );
      }
      return CustomerLookupResponseModel.fromJson(responseBody);
    } on CustomerLookupException {
      rethrow;
    } on TimeoutException {
      throw const CustomerLookupException(
        'El servicio tardó demasiado en consultar al aval.',
      );
    } on FormatException {
      throw const CustomerLookupException(
        'La respuesta de consulta del aval no es válida.',
      );
    } on http.ClientException {
      throw const CustomerLookupException(
        'No fue posible conectar con el servicio de clientes.',
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
    return 'No fue posible encontrar al cliente.';
  }
}
