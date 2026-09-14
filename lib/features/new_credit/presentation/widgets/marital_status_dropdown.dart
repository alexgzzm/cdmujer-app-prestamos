import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/marital_status_option.dart';
import 'package:flutter/material.dart';

class MaritalStatusDropdown extends StatelessWidget {
  const MaritalStatusDropdown({
    required this.controller,
    required this.maritalStatuses,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final TextEditingController controller;
  final List<MaritalStatusOption> maritalStatuses;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final bool hasSelectedMaritalStatus = maritalStatuses.any(
      (MaritalStatusOption maritalStatus) =>
          maritalStatus.value == controller.text,
    );
    final String? selectedValue =
        hasSelectedMaritalStatus ? controller.text : null;
    final bool isEnabled =
        !isLoading && errorMessage == null && maritalStatuses.isNotEmpty;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      onChanged:
          isEnabled ? (String? value) => controller.text = value ?? '' : null,
      items: maritalStatuses
          .map(
            (MaritalStatusOption maritalStatus) => DropdownMenuItem<String>(
              value: maritalStatus.value,
              child: Text(
                maritalStatus.description,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(growable: false),
      decoration: InputDecoration(
        labelText: 'Estado civil',
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
            ? 'Cargando estados civiles...'
            : maritalStatuses.isEmpty
                ? 'No hay estados civiles disponibles'
                : 'Selecciona un estado civil',
      ),
    );
  }
}
