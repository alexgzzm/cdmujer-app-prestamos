import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_group_option.dart';
import 'package:flutter/material.dart';

class LoanGroupDropdown extends StatelessWidget {
  const LoanGroupDropdown({
    required this.controller,
    required this.groups,
    required this.isLoading,
    required this.errorMessage,
    required this.isRouteSelected,
    required this.onRetry,
    super.key,
  });

  final TextEditingController controller;
  final List<LoanGroupOption> groups;
  final bool isLoading;
  final String? errorMessage;
  final bool isRouteSelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final Map<String, LoanGroupOption> groupsByValue =
        <String, LoanGroupOption>{
      for (final LoanGroupOption group in groups) group.value: group,
    };
    final List<LoanGroupOption> uniqueGroups = groupsByValue.values.toList(
      growable: false,
    );
    final bool hasSelectedGroup =
        uniqueGroups.any(
          (LoanGroupOption group) => group.value == controller.text,
        );
    final String? selectedValue = hasSelectedGroup ? controller.text : null;
    final bool isEnabled =
        isRouteSelected &&
        !isLoading &&
        errorMessage == null &&
        uniqueGroups.isNotEmpty;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      onChanged: isEnabled ? (String? value) => controller.text = value ?? '' : null,
      items: uniqueGroups
          .map(
            (LoanGroupOption group) => DropdownMenuItem<String>(
              value: group.value,
              child: Text(group.description, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(growable: false),
      decoration: InputDecoration(
        labelText: 'Grupo',
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
        !isRouteSelected
            ? 'Selecciona una ruta primero'
            : isLoading
                ? 'Cargando grupos...'
                : groups.isEmpty
                    ? 'No hay grupos disponibles'
                    : 'Selecciona un grupo',
      ),
    );
  }
}
