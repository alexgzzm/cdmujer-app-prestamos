import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/loan_route_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_route_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/loan_route_repository.dart';

class LoanRouteRepositoryImpl implements LoanRouteRepository {
  LoanRouteRepositoryImpl({required LoanRouteRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final LoanRouteRemoteDataSource _dataSource;

  @override
  Future<List<LoanRouteOption>> getRoutes({required String token}) async {
    final routes = await _dataSource.getRoutes(token: token);
    return routes
        .map((route) => route.toEntity())
        .toList(growable: false);
  }
}
