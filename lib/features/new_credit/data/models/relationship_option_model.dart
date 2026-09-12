import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/relationship_option.dart';

class RelationshipOptionModel {
  const RelationshipOptionModel({
    required this.value,
    required this.description,
  });

  factory RelationshipOptionModel.fromJson(Map<String, dynamic> json) {
    final String value = json['value']?.toString().trim() ?? '';
    final String description = json['description']?.toString().trim() ?? '';
    if (value.isEmpty || description.isEmpty) {
      throw const FormatException(
        'La respuesta de parentescos no es válida.',
      );
    }
    return RelationshipOptionModel(value: value, description: description);
  }

  final String value;
  final String description;

  RelationshipOption toEntity() {
    return RelationshipOption(value: value, description: description);
  }
}
