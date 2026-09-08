import 'package:flutter/material.dart';

class CreditFieldDefinition {
  const CreditFieldDefinition({
    required this.name,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  final String name;
  final String label;
  final TextInputType keyboardType;
  final int maxLines;
}

class ResponsiveFormFields extends StatelessWidget {
  const ResponsiveFormFields({
    required this.fields,
    required this.controllers,
    super.key,
  });

  final List<CreditFieldDefinition> fields;
  final Map<String, TextEditingController> controllers;

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
              child: TextFormField(
                controller: controllers[field.name],
                keyboardType: field.maxLines > 1
                    ? TextInputType.multiline
                    : field.keyboardType,
                maxLines: field.maxLines,
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
