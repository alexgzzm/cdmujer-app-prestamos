import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/marital_status_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/repositories/marital_status_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/marital_status_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<MaritalStatusRepository> maritalStatusRepositoryProvider =
    Provider<MaritalStatusRepository>((Ref ref) {
  return MaritalStatusRepositoryImpl(
    dataSource: MaritalStatusRemoteDataSource(
      client: ref.watch(httpClientProvider),
    ),
  );
});
