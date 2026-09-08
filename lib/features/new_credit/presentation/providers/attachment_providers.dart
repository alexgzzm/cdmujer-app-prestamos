import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/attachment_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/ine_data_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/repositories/attachment_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/repositories/ine_data_repository_impl.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/attachment_repository.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/ine_data_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<AttachmentRepository> attachmentRepositoryProvider =
    Provider<AttachmentRepository>((Ref ref) {
  return AttachmentRepositoryImpl(
    dataSource: AttachmentRemoteDataSource(
      client: ref.watch(httpClientProvider),
    ),
  );
});

final Provider<IneDataRepository> ineDataRepositoryProvider =
    Provider<IneDataRepository>((Ref ref) {
  return IneDataRepositoryImpl(
    dataSource: IneDataRemoteDataSource(
      client: ref.watch(httpClientProvider),
    ),
  );
});
