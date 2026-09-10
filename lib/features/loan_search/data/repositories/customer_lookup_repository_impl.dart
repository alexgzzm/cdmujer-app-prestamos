import 'package:cdmujer_app_prestamos/features/loan_search/data/datasources/customer_lookup_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_name_match.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/repositories/customer_lookup_repository.dart';

class CustomerLookupRepositoryImpl implements CustomerLookupRepository {
  CustomerLookupRepositoryImpl({
    required CustomerLookupRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final CustomerLookupRemoteDataSource _dataSource;

  @override
  Future<CustomerLookupResult> search({
    required String loanNumber,
    required String curp,
    required String token,
  }) async {
    final response = await _dataSource.search(
      loanNumber: loanNumber,
      curp: curp,
      token: token,
    );
    return response.toEntity();
  }

  @override
  Future<List<CustomerNameMatch>> searchByName({
    required String name,
    required String lastname,
    required String surname,
    required String token,
  }) async {
    final response = await _dataSource.searchByName(
      name: name,
      lastname: lastname,
      surname: surname,
      token: token,
    );
    return response.map((model) => model.toEntity()).toList();
  }
}
