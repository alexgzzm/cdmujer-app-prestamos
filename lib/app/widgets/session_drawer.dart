import 'package:cdmujer_app_prestamos/app/theme/app_colors.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SessionDrawer extends ConsumerWidget {
  const SessionDrawer({this.confirmHomeExit = false, super.key});

  final bool confirmHomeExit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AuthSession?> sessionState =
        ref.watch(authControllerProvider);
    final AuthSession? session = sessionState.whenOrNull(
      data: (AuthSession? value) => value,
    );

    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person_outline,
                color: AppColors.primary,
                size: 34,
              ),
            ),
            accountName: Text(session?.user.name ?? 'Usuario'),
            accountEmail: Text(session?.user.username ?? 'Usuario'),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Inicio'),
            onTap: () => _goHome(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            enabled: !sessionState.isLoading,
            onTap: sessionState.isLoading
                ? null
                : () => _signOut(context: context, ref: ref),
          ),
        ],
      ),
    );
  }

  Future<void> _goHome(BuildContext context) async {
    if (confirmHomeExit) {
      final bool shouldContinue = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text(
                  'Los datos capturados se perderán, ¿desea continuar?',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Continuar'),
                  ),
                ],
              );
            },
          ) ??
          false;
      if (!shouldContinue || !context.mounted) {
        return;
      }
    }

    Navigator.of(context).pop();
    context.go('/home');
  }

  Future<void> _signOut({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    Navigator.of(context).pop();
    final bool success =
        await ref.read(authControllerProvider.notifier).signOut();

    if (!context.mounted) {
      return;
    }

    if (success) {
      context.go('/login');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No fue posible cerrar sesión'),
          content: const Text('Intenta nuevamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }
}
