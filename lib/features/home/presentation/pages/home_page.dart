import 'package:cdmujer_app_prestamos/features/home/presentation/widgets/module_navigation_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Gestión de préstamos',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            const ModuleNavigationCard(label: 'Clientes', route: '/clients'),
            const SizedBox(height: 12),
            const ModuleNavigationCard(label: 'Préstamos', route: '/loans'),
            const SizedBox(height: 12),
            const ModuleNavigationCard(label: 'Pagos', route: '/payments'),
          ],
        ),
      ),
    );
  }
}
