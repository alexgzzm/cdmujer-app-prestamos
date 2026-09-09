import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/city_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/repositories/city_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/city_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<CityRepository> cityRepositoryProvider =
    Provider<CityRepository>((Ref ref) {
  return CityRepositoryImpl(
    dataSource: CityRemoteDataSource(client: ref.watch(httpClientProvider)),
  );
});
