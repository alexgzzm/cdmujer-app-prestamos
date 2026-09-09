import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_creation_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/repositories/loan_creation_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/loan_creation_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<LoanCreationRepository> loanCreationRepositoryProvider =
    Provider<LoanCreationRepository>((Ref ref) {
  return LoanCreationRepositoryImpl(
    dataSource: LoanCreationRemoteDataSource(
      client: ref.watch(httpClientProvider),
    ),
  );
});
