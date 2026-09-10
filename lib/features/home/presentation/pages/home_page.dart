import 'package:cdmujer_app_prestamos/features/home/presentation/widgets/home_action_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              HomeActionButton(
                label: 'Nuevo Crédito',
                icon: Icons.add_card_outlined,
                onPressed: () => context.go('/new-credit'),
              ),
              const SizedBox(height: 20),
              HomeActionButton(
                label: 'Renovación',
                icon: Icons.autorenew,
                onPressed: () => context.go('/renewal'),
              ),
              const SizedBox(height: 20),
              HomeActionButton(
                label: 'Reingreso',
                icon: Icons.login,
                onPressed: () => context.go('/reentry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
