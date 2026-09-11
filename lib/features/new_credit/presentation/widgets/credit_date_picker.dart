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
    this.firstDate,
    this.lastDate,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final CreditDatePickerCallback? pickDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

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
    final DateTime minimumDate = firstDate ?? DateTime(2000);
    final DateTime maximumDate = lastDate ?? DateTime(2100);
    final DateTime initialDate = _dateWithinRange(
      parseCreditDate(controller.text) ?? DateTime.now(),
      minimumDate,
      maximumDate,
    );
    final DateTime? selectedDate = await (pickDate?.call(context, initialDate) ??
        showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: minimumDate,
          lastDate: maximumDate,
          locale: const Locale('es', 'MX'),
        ));
    if (selectedDate != null) {
      controller.text = formatCreditDate(selectedDate);
    }
  }
}

DateTime latestAdultBirthDate(DateTime currentDate) {
  final int eligibleYear = currentDate.year - 18;
  final int lastDayOfMonth =
      DateTime.utc(eligibleYear, currentDate.month + 1, 0).day;
  return DateTime.utc(
    eligibleYear,
    currentDate.month,
    currentDate.day.clamp(1, lastDayOfMonth).toInt(),
  );
}

DateTime _dateWithinRange(
  DateTime date,
  DateTime minimumDate,
  DateTime maximumDate,
) {
  if (date.isBefore(minimumDate)) {
    return minimumDate;
  }
  if (date.isAfter(maximumDate)) {
    return maximumDate;
  }
  return date;
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
