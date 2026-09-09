import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/ine_extracted_data.dart';

class IneExtractionResponseModel {
  IneExtractionResponseModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as bool? ?? true,
        data = _parseData(_selectPayload(json));

  final bool status;
  final IneExtractedData data;

  IneExtractedData toEntity() => data;

  static IneExtractedData _parseData(Map<String, dynamic> json) {
    return IneExtractedData(
      lastname: _readString(json, 'apellidoPaterno'),
      surname: _readString(json, 'apellidoMaterno'),
      name: _readString(json, 'nombres'),
      street: _readString(json, 'calle'),
      suburb: _readString(json, 'colonia'),
      zipCode: _readString(json, 'codigoPostal'),
      curp: _readString(json, 'curp'),
    );
  }

  static Map<String, dynamic> _selectPayload(Map<String, dynamic> json) {
    for (final String key in <String>['data', 'result']) {
      final dynamic candidate = json[key];
      if (candidate is Map<String, dynamic>) {
        return candidate;
      }
    }
    return json;
  }

  static String? _readString(Map<String, dynamic> json, String expectedKey) {
    final String normalizedExpectedKey = expectedKey.toLowerCase();
    for (final MapEntry<String, dynamic> entry in json.entries) {
      if (entry.key.trim().toLowerCase() != normalizedExpectedKey) {
        continue;
      }
      final String value = entry.value?.toString().trim() ?? '';
      return value.isEmpty ? null : value;
    }
    return null;
  }
}
