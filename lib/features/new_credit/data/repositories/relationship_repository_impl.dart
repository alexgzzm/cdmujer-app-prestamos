import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/relationship_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/relationship_option.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/relationship_repository.dart';

class RelationshipRepositoryImpl implements RelationshipRepository {
  RelationshipRepositoryImpl({
    required RelationshipRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final RelationshipRemoteDataSource _dataSource;

  @override
  Future<List<RelationshipOption>> getRelationships({
    required String token,
  }) async {
    final relationships = await _dataSource.getRelationships(token: token);
    return relationships
        .map((relationship) => relationship.toEntity())
        .toList(growable: false);
  }
}
