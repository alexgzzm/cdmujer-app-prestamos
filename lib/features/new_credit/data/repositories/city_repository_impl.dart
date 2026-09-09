import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/city_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/city_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/city_repository.dart';

class CityRepositoryImpl implements CityRepository {
  CityRepositoryImpl({required CityRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final CityRemoteDataSource _dataSource;

  @override
  Future<List<CityOption>> getCities({
    required String stateId,
    required String token,
  }) async {
    final cities = await _dataSource.getCities(
      stateId: stateId,
      token: token,
    );
    return cities.map((city) => city.toEntity()).toList(growable: false);
  }
}
