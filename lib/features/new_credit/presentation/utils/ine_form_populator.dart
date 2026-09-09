import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/ine_extracted_data.dart';
import 'package:flutter/material.dart';

abstract final class IneFormPopulator {
  static void apply({
    required IneExtractedData data,
    required Map<String, TextEditingController> controllers,
  }) {
    _setText(controllers['lastname'], data.lastname);
    _setText(controllers['surname'], data.surname);
    _setText(controllers['name'], data.name);
    _setText(controllers['street'], data.street);
    _setText(controllers['suburb'], data.suburb);
    _setText(controllers['zipCode'], data.zipCode);
    _setText(controllers['curp'], data.curp);
  }

  static void _setText(TextEditingController? controller, String? value) {
    if (controller == null || value == null) {
      return;
    }
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}
