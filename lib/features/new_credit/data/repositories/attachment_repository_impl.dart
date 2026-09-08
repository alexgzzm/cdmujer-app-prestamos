import 'dart:typed_data';

import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/attachment_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/attachment_upload_response_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/attachment_upload_result.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/attachment_repository.dart';

class AttachmentRepositoryImpl implements AttachmentRepository {
  AttachmentRepositoryImpl({required AttachmentRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final AttachmentRemoteDataSource _dataSource;

  @override
  Future<AttachmentUploadResult> upload({
    required Uint8List bytes,
    required String fileName,
    required String? contentType,
    required int fileType,
    required String token,
  }) async {
    final AttachmentUploadResponseModel response = await _dataSource.upload(
      bytes: bytes,
      fileName: fileName,
      contentType: contentType,
      fileType: fileType,
      token: token,
    );
    return response.toEntity();
  }
}
