import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/ine_extracted_data.dart';

class IneExtractionResponseModel {
  IneExtractionResponseModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as bool? ?? true,
        values = _extractValues(json);

  final bool status;
  final Map<String, String> values;

  IneExtractedData toEntity() => IneExtractedData(values: values);

  static const Map<String, List<String>> _aliases =
      <String, List<String>>{
    'client': <String>['client', 'numeroCliente'],
    'lastname': <String>[
      'lastname',
      'lastName',
      'apellidoPaterno',
      'primerApellido',
      'firstLastName',
      'paternalLastName',
      'paternalSurname',
      'paterno',
    ],
    'surname': <String>[
      'surname',
      'apellidoMaterno',
      'segundoApellido',
      'secondLastName',
      'maternalLastName',
      'maternalSurname',
      'materno',
    ],
    'name': <String>['name', 'firstName', 'givenNames', 'nombre', 'nombres'],
    'gender': <String>['gender', 'genero', 'sexo'],
    'street': <String>[
      'street',
      'streetName',
      'calle',
      'address',
      'direccion',
    ],
    'betweenStreets': <String>['betweenStreets', 'entreCalles'],
    'extNum': <String>[
      'extNum',
      'numeroExterior',
      'numExterior',
      'noExterior',
      'exteriorNumber',
      'houseNumber',
    ],
    'intNum': <String>[
      'intNum',
      'numeroInterior',
      'numInterior',
      'noInterior',
      'interiorNumber',
    ],
    'suburb': <String>[
      'suburb',
      'neighborhood',
      'colonia',
      'asentamiento',
    ],
    'city': <String>[
      'city',
      'ciudad',
      'municipio',
      'alcaldia',
      'localidad',
    ],
    'state': <String>['state', 'estado', 'entidad', 'entidadFederativa'],
    'zipCode': <String>['zipCode', 'postalCode', 'codigoPostal', 'cp'],
    'phoneNumber': <String>['phoneNumber', 'telefono'],
    'phoneNumber2': <String>['phoneNumber2', 'telefono2'],
    'mobileNumber': <String>['mobileNumber', 'celular'],
    'mobileNumber2': <String>['mobileNumber2', 'celular2'],
    'maritalStatus': <String>['maritalStatus', 'estadoCivil'],
    'rfc': <String>['rfc'],
    'curp': <String>['curp'],
    'ine': <String>['ine', 'claveElector', 'claveDeElector', 'cic'],
    'passport': <String>['passport', 'pasaporte'],
    'originCountry': <String>[
      'originCountry',
      'paisOrigen',
      'paisDeOrigen',
    ],
  };

  static Map<String, String> _extractValues(Map<String, dynamic> json) {
    final Map<String, dynamic> payload = _selectPayload(json);

    final Map<String, String> flattened = <String, String>{};
    _flatten(payload, flattened);
    final Map<String, String> result = <String, String>{};
    for (final MapEntry<String, List<String>> entry in _aliases.entries) {
      final String? value = _findValue(flattened, entry.value);
      if (value != null) {
        result[entry.key] = value;
      }
    }
    return result;
  }

  static Map<String, dynamic> _selectPayload(Map<String, dynamic> json) {
    for (final String key in <String>[
      'data',
      'result',
      'customer',
      'clientData',
      'ineData',
    ]) {
      final dynamic candidate = json[key];
      if (candidate is Map<String, dynamic>) {
        return candidate;
      }
    }
    return json;
  }

  static void _flatten(
    Map<String, dynamic> source,
    Map<String, String> destination,
  ) {
    for (final MapEntry<String, dynamic> entry in source.entries) {
      final dynamic value = entry.value;
      if (value is String && value.trim().isNotEmpty) {
        destination.putIfAbsent(
          _normalize(entry.key),
          () => value.trim(),
        );
      } else if (value is num || value is bool) {
        destination.putIfAbsent(
          _normalize(entry.key),
          () => value.toString(),
        );
      } else if (value is Map<String, dynamic>) {
        _flatten(value, destination);
      }
    }
  }

  static String? _findValue(
    Map<String, String> values,
    List<String> aliases,
  ) {
    for (final String alias in aliases) {
      final String? value = values[_normalize(alias)];
      if (value != null && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  static String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ñ', 'n')
        .replaceAll(RegExp('[^a-z0-9]'), '');
  }
}
