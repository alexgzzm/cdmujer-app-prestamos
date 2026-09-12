import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/relationship_option.dart';
import 'package:flutter/material.dart';

class RelationshipDropdown extends StatelessWidget {
  const RelationshipDropdown({
    required this.controller,
    required this.relationships,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final TextEditingController controller;
  final List<RelationshipOption> relationships;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final bool hasSelectedRelationship = relationships.any(
      (RelationshipOption relationship) =>
          relationship.value == controller.text,
    );
    final String? selectedValue =
        hasSelectedRelationship ? controller.text : null;
    final bool isEnabled =
        !isLoading && errorMessage == null && relationships.isNotEmpty;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      onChanged: isEnabled
          ? (String? value) => controller.text = value ?? ''
          : null,
      items: relationships
          .map(
            (RelationshipOption relationship) => DropdownMenuItem<String>(
              value: relationship.value,
              child: Text(
                relationship.description,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(growable: false),
      decoration: InputDecoration(
        labelText: 'Parentesco',
        border: const OutlineInputBorder(),
        errorText: errorMessage,
        suffixIcon: isLoading
            ? const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : errorMessage != null
                ? IconButton(
                    tooltip: 'Reintentar',
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                  )
                : null,
      ),
      hint: Text(
        isLoading
            ? 'Cargando parentescos...'
            : relationships.isEmpty
                ? 'No hay parentescos disponibles'
                : 'Selecciona un parentesco',
      ),
    );
  }
}
