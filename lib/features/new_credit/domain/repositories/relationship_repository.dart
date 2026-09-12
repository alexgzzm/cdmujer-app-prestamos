import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/relationship_option.dart';

abstract interface class RelationshipRepository {
  Future<List<RelationshipOption>> getRelationships({required String token});
}
