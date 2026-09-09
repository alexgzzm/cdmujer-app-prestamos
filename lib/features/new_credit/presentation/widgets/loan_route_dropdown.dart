import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_route_option.dart';
import 'package:flutter/material.dart';

class LoanRouteDropdown extends StatelessWidget {
  const LoanRouteDropdown({
    required this.controller,
    required this.routes,
    required this.isLoading,
    required this.errorMessage,
    required this.onRetry,
    super.key,
  });

  final TextEditingController controller;
  final List<LoanRouteOption> routes;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final bool hasSelectedRoute =
        routes.any((LoanRouteOption route) => route.value == controller.text);
    final String? selectedValue = hasSelectedRoute ? controller.text : null;

    return DropdownButtonFormField<String>(
      value: selectedValue,
      isExpanded: true,
      onChanged: isLoading || errorMessage != null || routes.isEmpty
          ? null
          : (String? value) => controller.text = value ?? '',
      items: routes
          .map(
            (LoanRouteOption route) => DropdownMenuItem<String>(
              value: route.value,
              child: Text(
                route.description,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
          .toList(growable: false),
      decoration: InputDecoration(
        labelText: 'Ruta',
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
            ? 'Cargando rutas...'
            : routes.isEmpty
                ? 'No hay rutas disponibles'
                : 'Selecciona una ruta',
      ),
    );
  }
}
