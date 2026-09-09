import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/state_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/state_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/state_repository.dart';

class StateRepositoryImpl implements StateRepository {
  StateRepositoryImpl({required StateRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final StateRemoteDataSource _dataSource;

  @override
  Future<List<StateOption>> getStates({required String token}) async {
    final states = await _dataSource.getStates(token: token);
    return states.map((state) => state.toEntity()).toList(growable: false);
  }
}
