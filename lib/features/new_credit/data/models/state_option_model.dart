import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/state_option.dart';

class StateOptionModel {
  const StateOptionModel({required this.value, required this.description});

  factory StateOptionModel.fromJson(Map<String, dynamic> json) {
    final String value = json['value']?.toString().trim() ?? '';
    final String description = json['description']?.toString().trim() ?? '';
    if (value.isEmpty || description.isEmpty) {
      throw const FormatException('La respuesta de estados no es válida.');
    }
    return StateOptionModel(value: value, description: description);
  }

  final String value;
  final String description;

  StateOption toEntity() => StateOption(value: value, description: description);
}
