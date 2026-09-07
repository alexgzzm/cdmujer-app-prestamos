import 'package:cdmujer_app_prestamos/features/home/presentation/widgets/home_action_button.dart';
import 'package:flutter/material.dart';

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
            children: const <Widget>[
              HomeActionButton(
                label: 'Nuevo Crédito',
                icon: Icons.add_card_outlined,
              ),
              SizedBox(height: 20),
              HomeActionButton(
                label: 'Renovación',
                icon: Icons.autorenew,
              ),
              SizedBox(height: 20),
              HomeActionButton(
                label: 'Reingreso',
                icon: Icons.login,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
