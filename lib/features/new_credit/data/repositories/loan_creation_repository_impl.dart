import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_creation_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_creation.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/loan_creation_repository.dart';

class LoanCreationRepositoryImpl implements LoanCreationRepository {
  LoanCreationRepositoryImpl({required LoanCreationRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final LoanCreationRemoteDataSource _dataSource;

  @override
  Future<LoanCreationResult> create({
    required LoanCreationData data,
    required String token,
  }) async {
    final response = await _dataSource.create(data: data, token: token);
    return response.toEntity();
  }
}
