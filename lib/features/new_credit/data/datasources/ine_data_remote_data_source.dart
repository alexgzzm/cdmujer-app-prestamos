import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/core/network/multipart_utils.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/ine_extraction_response_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/ine_extraction_exception.dart';
import 'package:http/http.dart' as http;

class IneDataRemoteDataSource {
  IneDataRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<IneExtractionResponseModel> extract({
    required Uint8List bytes,
    required String fileName,
    required String? contentType,
    required String token,
  }) async {
    final http.MultipartRequest request = http.MultipartRequest(
      'POST',
      ApiConfig.ineExtractionEndpoint,
    )
      ..headers['accept'] = '*/*'
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: fileName,
          contentType: MultipartUtils.imageContentType(contentType),
        ),
      );

    try {
      final http.StreamedResponse streamedResponse =
          await _client.send(request).timeout(const Duration(seconds: 45));
      final http.Response response =
          await http.Response.fromStream(streamedResponse);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw const IneExtractionException();
      }

      final dynamic responseBody = jsonDecode(response.body);
      if (responseBody is! Map<String, dynamic>) {
        throw const IneExtractionException();
      }

      final IneExtractionResponseModel result =
          IneExtractionResponseModel.fromJson(responseBody);
      if (!result.status || !result.data.hasValues) {
        throw const IneExtractionException();
      }
      return result;
    } on IneExtractionException {
      rethrow;
    } on Object {
      throw const IneExtractionException();
    }
  }
}
