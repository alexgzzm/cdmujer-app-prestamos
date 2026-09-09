import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_group_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_group_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/loan_group_repository.dart';

class LoanGroupRepositoryImpl implements LoanGroupRepository {
  LoanGroupRepositoryImpl({required LoanGroupRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final LoanGroupRemoteDataSource _dataSource;

  @override
  Future<List<LoanGroupOption>> getGroups({
    required String routeId,
    required String token,
  }) async {
    final groups = await _dataSource.getGroups(routeId: routeId, token: token);
    return groups.map((group) => group.toEntity()).toList(growable: false);
  }
}
