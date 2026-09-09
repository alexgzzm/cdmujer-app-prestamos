import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_information_validation_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/repositories/loan_information_validation_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/loan_information_validation_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<LoanInformationValidationRepository>
    loanInformationValidationRepositoryProvider =
    Provider<LoanInformationValidationRepository>((Ref ref) {
  return LoanInformationValidationRepositoryImpl(
    dataSource: LoanInformationValidationRemoteDataSource(
      client: ref.watch(httpClientProvider),
    ),
  );
});
