import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_group_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/repositories/loan_group_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/loan_group_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<LoanGroupRepository> loanGroupRepositoryProvider =
    Provider<LoanGroupRepository>((Ref ref) {
  return LoanGroupRepositoryImpl(
    dataSource: LoanGroupRemoteDataSource(client: ref.watch(httpClientProvider)),
  );
});
