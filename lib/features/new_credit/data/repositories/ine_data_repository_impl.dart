import 'dart:typed_data';

import 'package:cdmujer_app_prestamos/features/new_credit/data/datasources/ine_data_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/data/models/ine_extraction_response_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/ine_extracted_data.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/repositories/ine_data_repository.dart';

class IneDataRepositoryImpl implements IneDataRepository {
  IneDataRepositoryImpl({required IneDataRemoteDataSource dataSource})
      : _dataSource = dataSource;

  final IneDataRemoteDataSource _dataSource;

  @override
  Future<IneExtractedData> extract({
    required Uint8List bytes,
    required String fileName,
    required String? contentType,
    required String token,
  }) async {
    final IneExtractionResponseModel response = await _dataSource.extract(
      bytes: bytes,
      fileName: fileName,
      contentType: contentType,
      token: token,
    );
    return response.toEntity();
  }
}
