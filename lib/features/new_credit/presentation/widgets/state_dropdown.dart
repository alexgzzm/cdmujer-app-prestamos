import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/state_option.dart';
import 'package:flutter/material.dart';

class StateDropdown extends StatelessWidget {
  const StateDropdown({
    required this.controller,
    required this.states,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final TextEditingController controller;
  final List<StateOption> states;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final bool hasSelectedState =
        states.any((StateOption state) => state.value == controller.text);
    final String? selectedValue = hasSelectedState ? controller.text : null;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      onChanged: isLoading || errorMessage != null || states.isEmpty
          ? null
          : (String? value) => controller.text = value ?? '',
      items: states
          .map(
            (StateOption state) => DropdownMenuItem<String>(
              value: state.value,
              child: Text(state.description, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(growable: false),
      decoration: InputDecoration(
        labelText: 'Estado',
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
            ? 'Cargando estados...'
            : states.isEmpty
                ? 'No hay estados disponibles'
                : 'Selecciona un estado',
      ),
    );
  }
}
