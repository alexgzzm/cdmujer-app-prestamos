import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_route_option.dart';

class LoanRouteOptionModel {
  const LoanRouteOptionModel({
    required this.value,
    required this.description,
  });

  factory LoanRouteOptionModel.fromJson(Map<String, dynamic> json) {
    final String value = json['value']?.toString().trim() ?? '';
    final String description = json['description']?.toString().trim() ?? '';
    if (value.isEmpty || description.isEmpty) {
      throw const FormatException('La respuesta de rutas no es válida.');
    }

    return LoanRouteOptionModel(value: value, description: description);
  }

  final String value;
  final String description;

  LoanRouteOption toEntity() {
    return LoanRouteOption(value: value, description: description);
  }
}
