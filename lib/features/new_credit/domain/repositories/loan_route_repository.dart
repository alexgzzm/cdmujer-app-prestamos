import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_route_option.dart';

abstract interface class LoanRouteRepository {
  Future<List<LoanRouteOption>> getRoutes({required String token});
}
