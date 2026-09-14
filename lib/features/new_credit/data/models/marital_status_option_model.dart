import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/marital_status_option.dart';

class MaritalStatusOptionModel {
  const MaritalStatusOptionModel({
    required this.value,
    required this.description,
  });

  factory MaritalStatusOptionModel.fromJson(Map<String, dynamic> json) {
    final String value = json['value']?.toString().trim() ?? '';
    final String description = json['description']?.toString().trim() ?? '';
    if (value.isEmpty || description.isEmpty) {
      throw const FormatException(
        'La respuesta de estados civiles no es válida.',
      );
    }
    return MaritalStatusOptionModel(
      value: value,
      description: description,
    );
  }

  final String value;
  final String description;

  MaritalStatusOption toEntity() {
    return MaritalStatusOption(value: value, description: description);
  }
}
