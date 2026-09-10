import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';

abstract interface class CustomerLookupRepository {
  Future<CustomerLookupResult> search({
    required String loanNumber,
    required String curp,
    required String token,
  });
}
