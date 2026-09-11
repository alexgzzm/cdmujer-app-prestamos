import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_information_validation_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_information_validation.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/loan_information_validation_repository.dart';

class LoanInformationValidationRepositoryImpl
    implements LoanInformationValidationRepository {
  LoanInformationValidationRepositoryImpl({
    required LoanInformationValidationRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final LoanInformationValidationRemoteDataSource _dataSource;

  @override
  Future<LoanInformationValidation> validate({
    required String curp,
    required int? idCustomer,
    required String token,
  }) async {
    final result = await _dataSource.validate(
      curp: curp,
      idCustomer: idCustomer,
      token: token,
    );
    return result.toEntity();
  }
}
