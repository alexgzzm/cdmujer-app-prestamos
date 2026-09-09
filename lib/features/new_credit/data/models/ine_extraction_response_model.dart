import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/ine_extracted_data.dart';

class IneExtractionResponseModel {
  const IneExtractionResponseModel._({
    required this.status,
    required this.data,
  });

  factory IneExtractionResponseModel.fromJson(Map<String, dynamic> json) {
    return IneExtractionResponseModel._(
      status: json['status'] as bool? ?? true,
      data: _parseData(
        payload: _selectPayload(json),
        fullResponse: json,
      ),
    );
  }

  final bool status;
  final IneExtractedData data;

  IneExtractedData toEntity() => data;

  static IneExtractedData _parseData({
    required Map<String, dynamic> payload,
    required Map<String, dynamic> fullResponse,
  }) {
    return IneExtractedData(
      lastname: _readString(payload, 'apellidoPaterno'),
      surname: _readString(payload, 'apellidoMaterno'),
      name: _readString(payload, 'nombres'),
      street: _readString(payload, 'calle'),
      suburb: _readString(payload, 'colonia'),
      zipCode: _readString(payload, 'codigoPostal'),
      curp: _findCurp(fullResponse),
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
    final String normalizedExpectedKey = _normalizeKey(expectedKey);
    for (final MapEntry<String, dynamic> entry in json.entries) {
      if (_normalizeKey(entry.key) != normalizedExpectedKey) {
        continue;
      }
      return _asNonEmptyString(entry.value);
    }
    return null;
  }

  static String? _findCurp(Object? source) {
    if (source is Map) {
      for (final MapEntry<dynamic, dynamic> entry in source.entries) {
        if (_normalizeKey(entry.key.toString()) == 'curp') {
          final String? value = _asNonEmptyString(entry.value);
          if (value != null) {
            return value.toUpperCase();
          }
        }
      }
      for (final dynamic value in source.values) {
        final String? curp = _findCurp(value);
        if (curp != null) {
          return curp;
        }
      }
      return null;
    }
    if (source is Iterable) {
      for (final dynamic value in source) {
        final String? curp = _findCurp(value);
        if (curp != null) {
          return curp;
        }
      }
      return null;
    }
    final String? value = _asNonEmptyString(source)?.toUpperCase();
    if (value != null && _curpPattern.hasMatch(value)) {
      return value;
    }
    return null;
  }

  static String _normalizeKey(String key) {
    return key.trim().toLowerCase().replaceAll(RegExp('[^a-z0-9]'), '');
  }

  static String? _asNonEmptyString(Object? value) {
    final String text = value?.toString().trim() ?? '';
    return text.isEmpty ? null : text;
  }

  static final RegExp _curpPattern = RegExp(
    r'^[A-Z]{4}\d{6}[HM][A-Z]{5}[A-Z0-9]\d$',
  );
}
