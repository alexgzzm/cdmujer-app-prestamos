import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/data/datasources/customer_lookup_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/data/repositories/customer_lookup_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/repositories/customer_lookup_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<CustomerLookupRepository> customerLookupRepositoryProvider =
    Provider<CustomerLookupRepository>((Ref ref) {
  return CustomerLookupRepositoryImpl(
    dataSource: CustomerLookupRemoteDataSource(
      client: ref.watch(httpClientProvider),
    ),
  );
});
