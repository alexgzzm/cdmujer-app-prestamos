import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/relationship_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/repositories/relationship_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/relationship_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<RelationshipRepository> relationshipRepositoryProvider =
    Provider<RelationshipRepository>((Ref ref) {
  return RelationshipRepositoryImpl(
    dataSource: RelationshipRemoteDataSource(
      client: ref.watch(httpClientProvider),
    ),
  );
});
