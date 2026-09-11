import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/credit_date_picker.dart';
import 'package:flutter/material.dart';

abstract final class CustomerFormPopulator {
  static void apply({
    required CustomerLookupResult customer,
    required Map<String, TextEditingController> controllers,
  }) {
    _setText(controllers['lastname'], customer.lastname);
    _setText(controllers['surname'], customer.surname);
    _setText(controllers['name'], customer.name);
    _setText(controllers['birthDate'], formatCreditDate(customer.birthDate));
    _setText(controllers['gender'], customer.gender.toString());
    _setText(controllers['street'], customer.street);
    _setText(controllers['betweenStreets'], customer.betweenStreets);
    _setText(controllers['extNum'], customer.extNum);
    _setText(controllers['intNum'], customer.intNum);
    _setText(controllers['suburb'], customer.suburb);
    _setText(controllers['city'], customer.city.toString());
    _setText(controllers['state'], customer.state.toString());
    _setText(controllers['zipCode'], customer.zipCode);
    _setText(controllers['phoneNumber'], customer.phoneNumber ?? '');
    _setText(controllers['maritalStatus'], customer.maritalStatus.toString());
    _setText(controllers['curp'], customer.curp);
  }

  static void _setText(TextEditingController? controller, String value) {
    if (controller == null) {
      return;
    }
    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }
}
