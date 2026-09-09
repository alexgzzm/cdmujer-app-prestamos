import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/city_option.dart';
import 'package:flutter/material.dart';

class CityDropdown extends StatelessWidget {
  const CityDropdown({
    required this.controller,
    required this.cities,
    required this.isLoading,
    required this.errorMessage,
    required this.isStateSelected,
    required this.onRetry,
    super.key,
  });

  final TextEditingController controller;
  final List<CityOption> cities;
  final bool isLoading;
  final String? errorMessage;
  final bool isStateSelected;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final bool hasSelectedCity =
        cities.any((CityOption city) => city.value == controller.text);
    final String? selectedValue = hasSelectedCity ? controller.text : null;
    final bool isEnabled =
        isStateSelected && !isLoading && errorMessage == null && cities.isNotEmpty;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      onChanged: isEnabled ? (String? value) => controller.text = value ?? '' : null,
      items: cities
          .map(
            (CityOption city) => DropdownMenuItem<String>(
              value: city.value,
              child: Text(city.description, overflow: TextOverflow.ellipsis),
            ),
          )
          .toList(growable: false),
      decoration: InputDecoration(
        labelText: 'Municipio',
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
        !isStateSelected
            ? 'Selecciona un estado primero'
            : isLoading
                ? 'Cargando municipios...'
                : cities.isEmpty
                    ? 'No hay municipios disponibles'
                    : 'Selecciona un municipio',
      ),
    );
  }
}
