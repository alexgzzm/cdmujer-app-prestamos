import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CurrencyAmountField extends StatelessWidget {
  const CurrencyAmountField({
    required this.controller,
    required this.onDecimalChanged,
    this.label = 'Monto',
    this.readOnly = false,
    this.fieldKey,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onDecimalChanged;
  final String label;
  final bool readOnly;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: fieldKey ?? const Key('currency-amount-field'),
      controller: controller,
      readOnly: readOnly,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[CurrencyInputFormatter()],
      onChanged: readOnly
          ? null
          : (String value) => onDecimalChanged(normalizeCurrencyInput(value)),
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.attach_money),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String decimalValue = normalizeCurrencyInput(newValue.text);
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(decimalValue)) {
      return oldValue;
    }

    final String formattedValue = formatCurrencyInput(decimalValue);
    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}

String normalizeCurrencyInput(String value) {
  final String decimalValue = value.replaceAll(',', '');
  return decimalValue.startsWith('.') ? '0$decimalValue' : decimalValue;
}

String formatCurrencyInput(String value) {
  if (value.isEmpty) {
    return '';
  }

  final List<String> parts = value.split('.');
  final String integerPart = parts.first;
  final String formattedIntegerPart = integerPart.replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
    (Match match) => '${match[1]},',
  );
  return parts.length == 2 ? '$formattedIntegerPart.${parts[1]}' : formattedIntegerPart;
}
