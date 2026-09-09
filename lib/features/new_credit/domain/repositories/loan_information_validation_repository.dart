import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_information_validation.dart';

abstract interface class LoanInformationValidationRepository {
  Future<LoanInformationValidation> validate({
    required String curp,
    required String token,
  });
}
