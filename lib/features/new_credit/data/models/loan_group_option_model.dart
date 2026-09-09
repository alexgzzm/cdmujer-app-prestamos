import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_group_option.dart';

class LoanGroupOptionModel {
  const LoanGroupOptionModel({
    required this.value,
    required this.description,
  });

  factory LoanGroupOptionModel.fromJson(Map<String, dynamic> json) {
    final String value = json['value']?.toString().trim() ?? '';
    final String description = json['description']?.toString().trim() ?? '';
    if (value.isEmpty || description.isEmpty) {
      throw const FormatException('La respuesta de grupos no es válida.');
    }

    return LoanGroupOptionModel(value: value, description: description);
  }

  final String value;
  final String description;

  LoanGroupOption toEntity() {
    return LoanGroupOption(value: value, description: description);
  }
}
