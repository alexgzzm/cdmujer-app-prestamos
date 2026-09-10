import 'package:cdmujer_app_prestamos/app/widgets/app_scaffold.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/pages/login_page.dart';
import 'package:cdmujer_app_prestamos/features/clients/presentation/pages/clients_page.dart';
import 'package:cdmujer_app_prestamos/features/home/presentation/pages/home_page.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/presentation/pages/loan_search_page.dart';
import 'package:cdmujer_app_prestamos/features/loans/presentation/pages/loans_page.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/pages/new_credit_page.dart';
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
          confirmHomeExit: state.uri.path == '/new-credit',
          child: child,
        );
      },
      routes: <RouteBase>[
        GoRoute(path: '/home', builder: (context, state) => const HomePage()),
        GoRoute(
          path: '/new-credit',
          builder: (context, state) {
            final Object? extra = state.extra;
            if (extra is LoanSearchNavigationData) {
              return NewCreditPage(
                applicationType: extra.applicationType,
                initialClient: extra.customer,
              );
            }
            return const NewCreditPage(
              applicationType: NewCreditPage.newCreditType,
            );
          },
        ),
        GoRoute(
          path: '/renewal',
          builder: (context, state) => const LoanSearchPage(
            applicationType: LoanSearchPage.renewalType,
          ),
        ),
        GoRoute(
          path: '/reentry',
          builder: (context, state) => const LoanSearchPage(
            applicationType: LoanSearchPage.reentryType,
          ),
        ),
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
    '/new-credit' => 'Nuevo Crédito',
    '/renewal' => 'Renovación',
    '/reentry' => 'Reingreso',
    '/loans' => 'Préstamos',
    '/payments' => 'Pagos',
    _ => 'Inicio',
  };
}
