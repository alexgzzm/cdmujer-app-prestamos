import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';

class CustomerLookupResponseModel {
  const CustomerLookupResponseModel({required this.customer});

  factory CustomerLookupResponseModel.fromJson(Map<String, dynamic> json) {
    return CustomerLookupResponseModel(
      customer: CustomerLookupResult(
        id: _requiredInt(json, 'id'),
        lastname: _requiredString(json, 'lastname'),
        surname: _requiredString(json, 'surname'),
        name: _requiredString(json, 'name'),
        birthDate: _requiredDate(json, 'birthDate'),
        gender: _requiredInt(json, 'gender'),
        street: _requiredString(json, 'street'),
        betweenStreets: _requiredString(json, 'betweenStreets'),
        extNum: _requiredString(json, 'extNum'),
        intNum: _requiredString(json, 'intNum'),
        suburb: _requiredString(json, 'suburb'),
        city: _requiredInt(json, 'city'),
        state: _requiredInt(json, 'state'),
        zipCode: _requiredString(json, 'zipCode'),
        phoneNumber: json['phoneNumber']?.toString(),
        maritalStatus: _requiredInt(json, 'maritalStatus'),
        curp: _requiredString(json, 'curp'),
      ),
    );
  }

  final CustomerLookupResult customer;

  CustomerLookupResult toEntity() => customer;

  static String _requiredString(Map<String, dynamic> json, String key) {
    final dynamic value = json[key];
    if (value is! String) {
      throw const FormatException(
        'La respuesta de búsqueda del cliente no es válida.',
      );
    }
    return value;
  }

  static int _requiredInt(Map<String, dynamic> json, String key) {
    final int? value = int.tryParse(json[key]?.toString() ?? '');
    if (value == null) {
      throw const FormatException(
        'La respuesta de búsqueda del cliente no es válida.',
      );
    }
    return value;
  }

  static DateTime _requiredDate(Map<String, dynamic> json, String key) {
    final dynamic value = json[key];
    final DateTime? date = value is String ? DateTime.tryParse(value) : null;
    if (date == null) {
      throw const FormatException(
        'La respuesta de búsqueda del cliente no es válida.',
      );
    }
    return DateTime.utc(date.year, date.month, date.day);
  }
}
