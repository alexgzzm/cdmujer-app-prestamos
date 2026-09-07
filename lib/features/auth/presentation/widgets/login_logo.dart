import 'package:cdmujer_app_prestamos/core/constants/app_branding.dart';
import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        AppBranding.logoUrl,
        width: 240,
        height: 120,
        fit: BoxFit.contain,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          return const SizedBox(
            width: 240,
            height: 120,
            child: Center(child: Text('LOGOTIPO')),
          );
        },
      ),
    );
  }
}
