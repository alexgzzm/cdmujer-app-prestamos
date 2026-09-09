import 'package:flutter/material.dart';

typedef CreditDatePickerCallback = Future<DateTime?> Function(
  BuildContext context,
  DateTime initialDate,
);

class CreditDatePicker extends StatelessWidget {
  const CreditDatePicker({
    required this.controller,
    required this.label,
    this.pickDate,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final CreditDatePickerCallback? pickDate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: Key('credit-date-picker-$label'),
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate =
        parseCreditDate(controller.text) ?? DateTime.now();
    final DateTime? selectedDate = await (pickDate?.call(context, initialDate) ??
        showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          locale: const Locale('es', 'MX'),
        ));
    if (selectedDate != null) {
      controller.text = formatCreditDate(selectedDate);
    }
  }
}

String formatCreditDate(DateTime date) {
  final String day = date.day.toString().padLeft(2, '0');
  final String month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

DateTime? parseCreditDate(String value) {
  final List<String> parts = value.split('/');
  if (parts.length != 3) {
    return null;
  }
  final int? day = int.tryParse(parts[0]);
  final int? month = int.tryParse(parts[1]);
  final int? year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) {
    return null;
  }
  final DateTime date = DateTime.utc(year, month, day);
  return date.day == day && date.month == month && date.year == year
      ? date
      : null;
}
