import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/state_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/repositories/state_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/state_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<StateRepository> stateRepositoryProvider =
    Provider<StateRepository>((Ref ref) {
  return StateRepositoryImpl(
    dataSource: StateRemoteDataSource(client: ref.watch(httpClientProvider)),
  );
});
