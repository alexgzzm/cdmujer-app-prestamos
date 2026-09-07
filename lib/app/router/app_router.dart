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
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/clients', builder: (context, state) => const ClientsPage()),
    GoRoute(path: '/loans', builder: (context, state) => const LoansPage()),
    GoRoute(path: '/payments', builder: (context, state) => const PaymentsPage()),
  ],
);
import 'package:cdmujer_app_prestamos/features/auth/presentation/pages/login_page.dart';
