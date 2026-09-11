import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_balance.dart';

abstract interface class LoanBalanceRepository {
  Future<LoanBalance> getBalance({
    required int customerId,
    required String token,
  });
}
