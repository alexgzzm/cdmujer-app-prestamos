import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/attachment_upload_result.dart';

class AttachmentUploadResponseModel {
  const AttachmentUploadResponseModel({
    required this.id,
    required this.status,
    required this.message,
    required this.messageType,
  });

  factory AttachmentUploadResponseModel.fromJson(Map<String, dynamic> json) {
    final num? id = json['id'] as num?;
    if (id == null) {
      throw const FormatException('El servicio no devolvió el ID del archivo.');
    }

    return AttachmentUploadResponseModel(
      id: id.toInt(),
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      messageType: json['messageType'] as String? ?? '',
    );
  }

  final int id;
  final bool status;
  final String message;
  final String messageType;

  AttachmentUploadResult toEntity() {
    return AttachmentUploadResult(id: id, message: message);
  }
}
