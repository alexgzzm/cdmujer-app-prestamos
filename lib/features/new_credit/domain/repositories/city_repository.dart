import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/city_option.dart';

abstract interface class CityRepository {
  Future<List<CityOption>> getCities({
    required String stateId,
    required String token,
  });
}
