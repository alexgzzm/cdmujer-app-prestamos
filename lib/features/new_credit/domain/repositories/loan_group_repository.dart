import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_group_option.dart';

abstract interface class LoanGroupRepository {
  Future<List<LoanGroupOption>> getGroups({
    required String routeId,
    required String token,
  });
}
