import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/marital_status_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/marital_status_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/marital_status_repository.dart';

class MaritalStatusRepositoryImpl implements MaritalStatusRepository {
  MaritalStatusRepositoryImpl({
    required MaritalStatusRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final MaritalStatusRemoteDataSource _dataSource;

  @override
  Future<List<MaritalStatusOption>> getMaritalStatuses({
    required String token,
  }) async {
    final maritalStatuses = await _dataSource.getMaritalStatuses(token: token);
    return maritalStatuses
        .map((maritalStatus) => maritalStatus.toEntity())
        .toList(growable: false);
  }
}
