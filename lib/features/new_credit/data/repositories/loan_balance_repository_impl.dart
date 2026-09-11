import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_balance_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_balance.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/loan_balance_repository.dart';

class LoanBalanceRepositoryImpl implements LoanBalanceRepository {
  LoanBalanceRepositoryImpl({
    required LoanBalanceRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final LoanBalanceRemoteDataSource _dataSource;

  @override
  Future<LoanBalance> getBalance({
    required int customerId,
    required String token,
  }) async {
    final result = await _dataSource.getBalance(
      customerId: customerId,
      token: token,
    );
    return result.toEntity();
  }
}
