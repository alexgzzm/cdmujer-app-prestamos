import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cdmujer_app_prestamos/core/constants/api_config.dart';
import 'package:cdmujer_app_prestamos/core/network/multipart_utils.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/attachment_upload_response_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/attachment_upload_exception.dart';
import 'package:http/http.dart' as http;

class AttachmentRemoteDataSource {
  AttachmentRemoteDataSource({required http.Client client}) : _client = client;

  final http.Client _client;

  Future<AttachmentUploadResponseModel> upload({
    required Uint8List bytes,
    required String fileName,
    required String? contentType,
    required int fileType,
    required String token,
  }) async {
    final Uri endpoint = ApiConfig.attachmentsEndpoint.replace(
      queryParameters: <String, String>{'fileType': fileType.toString()},
    );
    final http.MultipartRequest request = http.MultipartRequest(
      'POST',
      endpoint,
    )
      ..headers['accept'] = '*/*'
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(
        http.MultipartFile.fromBytes(
          'formFile',
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
      final dynamic responseBody = response.body.isEmpty
          ? null
          : jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw AttachmentUploadException(_messageFrom(responseBody));
      }
      if (responseBody is! Map<String, dynamic>) {
        throw const AttachmentUploadException(
          'La respuesta del servicio de archivos no es válida.',
        );
      }

      final AttachmentUploadResponseModel result =
          AttachmentUploadResponseModel.fromJson(responseBody);
      if (!result.status) {
        throw AttachmentUploadException(
          result.message.isEmpty
              ? 'No fue posible cargar la imagen.'
              : result.message,
        );
      }
      return result;
    } on AttachmentUploadException {
      rethrow;
    } on TimeoutException {
      throw const AttachmentUploadException(
        'El servicio tardó demasiado en responder.',
      );
    } on FormatException {
      throw const AttachmentUploadException(
        'La respuesta del servicio de archivos no es válida.',
      );
    } on http.ClientException {
      throw const AttachmentUploadException(
        'No fue posible conectar con el servicio de archivos.',
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
    return 'No fue posible cargar la imagen.';
  }
}
