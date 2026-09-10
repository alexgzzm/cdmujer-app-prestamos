import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_name_match.dart';

class CustomerNameMatchModel {
  const CustomerNameMatchModel({required this.customer});

  factory CustomerNameMatchModel.fromJson(Map<String, dynamic> json) {
    return CustomerNameMatchModel(
      customer: CustomerNameMatch(
        id: _requiredInt(json, 'id'),
        name: _requiredString(json, 'name'),
        curp: _requiredString(json, 'curp'),
        lastLoan: _optionalString(json, 'lastLoan'),
        loanRoute: _optionalString(json, 'loanRoute'),
        loanGroup: _optionalString(json, 'loanGroup'),
      ),
    );
  }

  final CustomerNameMatch customer;

  CustomerNameMatch toEntity() => customer;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': customer.id,
      'name': customer.name,
      'curp': customer.curp,
      'lastLoan': customer.lastLoan,
      'loanRoute': customer.loanRoute,
      'loanGroup': customer.loanGroup,
    };
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final dynamic value = json[key];
    if (value is! String) {
      throw const FormatException(
        'La respuesta de búsqueda de clientes no es válida.',
      );
    }
    return value;
  }

  static int _requiredInt(Map<String, dynamic> json, String key) {
    final int? value = int.tryParse(json[key]?.toString() ?? '');
    if (value == null) {
      throw const FormatException(
        'La respuesta de búsqueda de clientes no es válida.',
      );
    }
    return value;
  }

  static String _optionalString(Map<String, dynamic> json, String key) {
    return json[key]?.toString() ?? '';
  }
}
