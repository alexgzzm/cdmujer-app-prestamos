enum LoanValidationMessageType { success, warning, error }

class LoanInformationValidation {
  const LoanInformationValidation({
    required this.id,
    required this.status,
    required this.message,
    required this.messageType,
  });

  final int? id;
  final bool status;
  final String message;
  final LoanValidationMessageType messageType;

  bool get shouldShowMessage => !status;

  bool get mustReturnHome =>
      shouldShowMessage && messageType == LoanValidationMessageType.error;
}
