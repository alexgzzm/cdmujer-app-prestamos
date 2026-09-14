import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/marital_status_option.dart';

abstract interface class MaritalStatusRepository {
  Future<List<MaritalStatusOption>> getMaritalStatuses({
    required String token,
  });
}
