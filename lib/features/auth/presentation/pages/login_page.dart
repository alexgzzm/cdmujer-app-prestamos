import 'package:cdmujer_app_prestamos/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/widgets/login_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<AuthSession?>>(authControllerProvider,
        (previous, next) {
      if (previous is AsyncLoading<AuthSession?> &&
          next is AsyncData<AuthSession?> &&
          next.value != null) {
        context.go('/home');
      }

      if (previous is AsyncLoading<AuthSession?> && next.hasError) {
        final Object error = next.error!;
        final String message = error is AuthException
            ? error.message
            : 'Ocurrió un error al iniciar sesión.';
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('No fue posible iniciar sesión'),
              content: Text(message),
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
    });

    final AsyncValue<AuthSession?> loginState =
        ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const LoginLogo(),
                    const SizedBox(height: 24),
                    Text(
                      'Iniciar sesión',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de usuario',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingresa tu nombre de usuario.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      onFieldSubmitted: (_) => _submit(),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa tu contraseña.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: loginState.isLoading ? null : _submit,
                      child: loginState.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Ingresar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    ref.read(authControllerProvider.notifier).signIn(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        );
  }
}
