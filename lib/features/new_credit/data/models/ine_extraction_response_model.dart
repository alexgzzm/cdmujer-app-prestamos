import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/ine_extracted_data.dart';

class IneExtractionResponseModel {
  IneExtractionResponseModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as bool? ?? true,
        values = _mapFormValues(_selectPayload(json));

  final bool status;
  final Map<String, String> values;

  IneExtractedData toEntity() => IneExtractedData(values: values);

  static Map<String, String> _mapFormValues(Map<String, dynamic> json) {
    final Map<String, String> values = <String, String>{};
    _addValue(values, 'lastname', _readString(json, 'apellidoPaterno'));
    _addValue(values, 'surname', _readString(json, 'apellidoMaterno'));
    _addValue(values, 'name', _readString(json, 'nombres'));
    _addValue(values, 'street', _readString(json, 'calle'));
    _addValue(values, 'suburb', _readString(json, 'colonia'));
    _addValue(values, 'zipCode', _readString(json, 'codigoPostal'));
    _addValue(values, 'curp', _readString(json, 'curp'));
    return values;
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
      if (entry.key.toLowerCase() != normalizedExpectedKey) {
        continue;
      }
      final String value = entry.value?.toString().trim() ?? '';
      return value.isEmpty ? null : value;
    }
    return null;
  }

  static void _addValue(
    Map<String, String> values,
    String field,
    String? value,
  ) {
    if (value != null) {
      values[field] = value;
    }
  }
}
