import 'package:cdmujer_app_prestamos/app/widgets/app_scaffold.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/pages/login_page.dart';
import 'package:cdmujer_app_prestamos/features/clients/presentation/pages/clients_page.dart';
import 'package:cdmujer_app_prestamos/features/home/presentation/pages/home_page.dart';
import 'package:cdmujer_app_prestamos/features/loans/presentation/pages/loans_page.dart';
import 'package:cdmujer_app_prestamos/features/payments/presentation/pages/payments_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(path: '/', redirect: (context, state) => '/login'),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    ShellRoute(
      builder: (context, state, child) {
        return AppScaffold(
          title: _titleForPath(state.uri.path),
          child: child,
        );
      },
      routes: <RouteBase>[
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/clients',
          builder: (context, state) => const ClientsPage(),
        ),
        GoRoute(path: '/loans', builder: (context, state) => const LoansPage()),
        GoRoute(
          path: '/payments',
          builder: (context, state) => const PaymentsPage(),
        ),
      ],
    ),
  ],
);

String _titleForPath(String path) {
  return switch (path) {
    '/clients' => 'Clientes',
    '/loans' => 'Préstamos',
    '/payments' => 'Pagos',
    _ => 'Inicio',
  };
}
