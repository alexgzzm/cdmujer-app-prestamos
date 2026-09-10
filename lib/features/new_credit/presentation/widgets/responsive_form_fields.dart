import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntegerRangeTextInputFormatter extends TextInputFormatter {
  const IntegerRangeTextInputFormatter({
    required this.minimum,
    required this.maximum,
  });

  final int minimum;
  final int maximum;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final int? value = int.tryParse(newValue.text);
    if (value == null || value < minimum || value > maximum) {
      return oldValue;
    }
    return newValue;
  }
}

class CreditFieldDefinition {
  const CreditFieldDefinition({
    required this.name,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters = const <TextInputFormatter>[],
    this.showCounter = true,
  });

  final String name;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter> inputFormatters;
  final bool showCounter;
}

class ResponsiveFormFields extends StatelessWidget {
  const ResponsiveFormFields({
    required this.fields,
    required this.controllers,
    this.fieldOverrides = const <String, Widget>{},
    super.key,
  });

  final List<CreditFieldDefinition> fields;
  final Map<String, TextEditingController> controllers;
  final Map<String, Widget> fieldOverrides;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double spacing = 16;
        final bool useTwoColumns = constraints.maxWidth >= 700;
        final double fieldWidth = useTwoColumns
            ? (constraints.maxWidth - spacing) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: fields.map((CreditFieldDefinition field) {
            return SizedBox(
              width: fieldWidth,
              child: fieldOverrides[field.name] ??
                  TextFormField(
                    controller: controllers[field.name],
                    keyboardType: field.maxLines > 1
                        ? TextInputType.multiline
                        : field.keyboardType,
                    maxLines: field.maxLines,
                    maxLength: field.maxLength,
                    inputFormatters: field.inputFormatters,
                    buildCounter: field.showCounter
                        ? null
                        : (
                            _, {
                            required int currentLength,
                            required bool isFocused,
                            required int? maxLength,
                          }) =>
                            null,
                    textInputAction: field.maxLines > 1
                        ? TextInputAction.newline
                        : TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: field.label,
                      border: const OutlineInputBorder(),
                      alignLabelWithHint: field.maxLines > 1,
                    ),
                  ),
            );
          }).toList(),
        );
      },
    );
  }
}
