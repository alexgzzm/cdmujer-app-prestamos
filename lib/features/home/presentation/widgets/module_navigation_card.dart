import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ModuleNavigationCard extends StatelessWidget {
  const ModuleNavigationCard({required this.label, required this.route, super.key});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go(route),
      ),
    );
  }
}
