import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_creation.dart';

abstract interface class LoanCreationRepository {
  Future<LoanCreationResult> create({
    required LoanCreationData data,
    required String token,
  });
}
