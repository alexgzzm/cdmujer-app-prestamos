import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/city_option.dart';

class CityOptionModel {
  const CityOptionModel({required this.value, required this.description});

  factory CityOptionModel.fromJson(Map<String, dynamic> json) {
    final String value = json['value']?.toString().trim() ?? '';
    final String description = json['description']?.toString().trim() ?? '';
    if (value.isEmpty || description.isEmpty) {
      throw const FormatException('La respuesta de municipios no es válida.');
    }
    return CityOptionModel(value: value, description: description);
  }

  final String value;
  final String description;

  CityOption toEntity() => CityOption(value: value, description: description);
}
