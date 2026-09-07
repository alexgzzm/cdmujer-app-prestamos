import 'package:flutter/material.dart';

class HomeActionButton extends StatelessWidget {
  const HomeActionButton({required this.label, required this.icon, super.key});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 32),
      label: Text(label),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(104),
        textStyle: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
