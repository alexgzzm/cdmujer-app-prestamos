import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_route_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/repositories/loan_route_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/loan_route_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<LoanRouteRepository> loanRouteRepositoryProvider =
    Provider<LoanRouteRepository>((Ref ref) {
  return LoanRouteRepositoryImpl(
    dataSource: LoanRouteRemoteDataSource(
      client: ref.watch(httpClientProvider),
    ),
  );
});
