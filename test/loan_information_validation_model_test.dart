import 'package:cdmujer_app_prestamos/features/new_credit/data/models/loan_information_validation_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_information_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps a successful silent validation response', () {
    final validation = LoanInformationValidationModel.fromJson(
      <String, dynamic>{
        'id': null,
        'status': true,
        'message': 'No existen prestamos asociados al RFC',
        'messageType': 'Success',
      },
    ).toEntity();

    expect(validation.status, isTrue);
    expect(validation.messageType, LoanValidationMessageType.success);
    expect(validation.shouldShowMessage, isFalse);
    expect(validation.mustReturnHome, isFalse);
  });

  test('warning validation shows a message without blocking the application', () {
    const LoanInformationValidation validation = LoanInformationValidation(
      id: 1,
      status: false,
      message: 'El cliente tiene información por revisar.',
      messageType: LoanValidationMessageType.warning,
    );

    expect(validation.shouldShowMessage, isTrue);
    expect(validation.mustReturnHome, isFalse);
  });

  test('error validation shows a message and blocks the application', () {
    const LoanInformationValidation validation = LoanInformationValidation(
      id: 1,
      status: false,
      message: 'El cliente tiene un préstamo abierto.',
      messageType: LoanValidationMessageType.error,
    );

    expect(validation.shouldShowMessage, isTrue);
    expect(validation.mustReturnHome, isTrue);
  });
}
