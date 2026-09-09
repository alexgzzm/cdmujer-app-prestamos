import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_creation.dart';

class LoanCreationResponseModel {
  const LoanCreationResponseModel({
    required this.id,
    required this.status,
    required this.message,
    required this.messageType,
  });

  factory LoanCreationResponseModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawId = json['id'];
    final dynamic rawStatus = json['status'];
    final String message = json['message']?.toString().trim() ?? '';
    final String messageType = json['messageType']?.toString().trim() ?? '';
    final int? id = rawId == null ? null : int.tryParse(rawId.toString());
    if (rawStatus is! bool ||
        message.isEmpty ||
        messageType.isEmpty ||
        (rawId != null && id == null) ||
        (rawStatus == true && id == null)) {
      throw const FormatException(
        'La respuesta de creación del crédito no es válida.',
      );
    }
    return LoanCreationResponseModel(
      id: id,
      status: rawStatus,
      message: message,
      messageType: messageType,
    );
  }

  final int? id;
  final bool status;
  final String message;
  final String messageType;

  LoanCreationResult toEntity() {
    return LoanCreationResult(
      id: id,
      status: status,
      message: message,
      messageType: messageType,
    );
  }
}
