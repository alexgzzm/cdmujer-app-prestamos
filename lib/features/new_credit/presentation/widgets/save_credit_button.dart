import 'package:flutter/material.dart';

class SaveCreditButton extends StatelessWidget {
  const SaveCreditButton({
    required this.isSaving,
    required this.onSave,
    super.key,
  });

  final bool isSaving;
  final Future<void> Function() onSave;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: FilledButton.icon(
        key: const Key('save-credit-button'),
        onPressed: isSaving ? null : () => _confirmSave(context),
        icon: isSaving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.save),
        label: Text(isSaving ? 'Guardando...' : 'Guardar'),
      ),
    );
  }

  Future<void> _confirmSave(BuildContext context) async {
    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmar guardado'),
              content: const Text('¿Deseas guardar este crédito?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (confirmed) {
      await onSave();
    }
  }
}
