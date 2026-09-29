import 'package:cdmujer_app_prestamos/app/router/app_router.dart';
import 'package:cdmujer_app_prestamos/app/theme/app_theme.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(authControllerProvider.notifier).checkSessionExpiry();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(sessionExpiredProvider, (bool? previous, bool expired) {
      if (!expired || previous == true) return;
      appRouter.go('/login');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _messengerKey.currentState
          ?..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Sesión caducada')),
          );
      });
    });

    return MaterialApp.router(
      scaffoldMessengerKey: _messengerKey,
      title: 'CD Mujer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      locale: const Locale('es', 'MX'),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[Locale('es', 'MX')],
      routerConfig: appRouter,
    );
  }
}
