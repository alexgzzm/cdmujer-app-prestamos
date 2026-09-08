import 'dart:typed_data';

import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/attachment_upload_result.dart';

abstract interface class AttachmentRepository {
  Future<AttachmentUploadResult> upload({
    required Uint8List bytes,
    required String fileName,
    required String? contentType,
    required int fileType,
    required String token,
  });
}
