import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_name_match.dart';

abstract interface class CustomerLookupRepository {
  Future<CustomerLookupResult> search({
    required String loanNumber,
    required String curp,
    required String token,
  });

  Future<List<CustomerNameMatch>> searchByName({
    required String name,
    required String lastname,
    required String surname,
    required String token,
  });

  Future<CustomerLookupResult> getById({
    required int customerId,
    required String token,
  });
}
