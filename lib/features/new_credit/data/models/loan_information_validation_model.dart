import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_information_validation.dart';

class LoanInformationValidationModel {
  const LoanInformationValidationModel({
    required this.id,
    required this.status,
    required this.message,
    required this.messageType,
  });

  factory LoanInformationValidationModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawId = json['id'];
    final dynamic rawStatus = json['status'];
    final String message = json['message']?.toString().trim() ?? '';
    final String rawMessageType =
        json['messageType']?.toString().trim().toLowerCase() ?? '';
    if (rawStatus is! bool || message.isEmpty) {
      throw const FormatException(
        'La respuesta de validación del CURP no es válida.',
      );
    }

    final LoanValidationMessageType messageType = switch (rawMessageType) {
      'success' => LoanValidationMessageType.success,
      'warning' => LoanValidationMessageType.warning,
      'error' => LoanValidationMessageType.error,
      _ => throw const FormatException(
          'El tipo de mensaje de validación no es válido.',
        ),
    };
    final int? id = rawId == null ? null : int.tryParse(rawId.toString());
    if (rawId != null && id == null) {
      throw const FormatException(
        'La respuesta de validación del CURP no es válida.',
      );
    }

    return LoanInformationValidationModel(
      id: id,
      status: rawStatus,
      message: message,
      messageType: messageType,
    );
  }

  final int? id;
  final bool status;
  final String message;
  final LoanValidationMessageType messageType;

  LoanInformationValidation toEntity() {
    return LoanInformationValidation(
      id: id,
      status: status,
      message: message,
      messageType: messageType,
    );
  }
}
