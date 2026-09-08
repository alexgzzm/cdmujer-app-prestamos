import 'dart:typed_data';

import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/ine_extracted_data.dart';

abstract interface class IneDataRepository {
  Future<IneExtractedData> extract({
    required Uint8List bytes,
    required String fileName,
    required String? contentType,
    required String token,
  });
}
