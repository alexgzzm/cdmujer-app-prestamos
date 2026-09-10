import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/errors/customer_lookup_exception.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/presentation/providers/customer_lookup_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

typedef CustomerLookupCallback = Future<CustomerLookupResult> Function({
  required String loanNumber,
  required String curp,
});

class LoanSearchPage extends ConsumerStatefulWidget {
  const LoanSearchPage({
    required this.applicationType,
    this.lookupCustomer,
    this.onCustomerSelected,
    super.key,
  }) : assert(
          applicationType == renewalType || applicationType == reentryType,
          'applicationType must identify renewal or reentry.',
        );

  static const int renewalType = 2;
  static const int reentryType = 3;

  final int applicationType;
  final CustomerLookupCallback? lookupCustomer;
  final ValueChanged<CustomerLookupResult>? onCustomerSelected;

  @override
  ConsumerState<LoanSearchPage> createState() => _LoanSearchPageState();
}

class _LoanSearchPageState extends ConsumerState<LoanSearchPage> {
  final TextEditingController _loanNumberController = TextEditingController();
  final TextEditingController _curpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _loanNumberController.dispose();
    _curpController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRenewal =
        widget.applicationType == LoanSearchPage.renewalType;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    isRenewal
                        ? 'Buscar crédito para renovación'
                        : 'Buscar crédito para reingreso',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Captura la información disponible para localizar el crédito.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _SearchFields(
                    loanNumberController: _loanNumberController,
                    curpController: _curpController,
                    nameController: _nameController,
                  ),
                  const SizedBox(height: 28),
                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 220,
                      height: 52,
                      child: FilledButton.icon(
                        key: const Key('loan-search-button'),
                        onPressed: _isSearching ? null : _searchCustomer,
                        icon: _isSearching
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(_isSearching ? 'Buscando...' : 'Buscar'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _searchCustomer() async {
    final String loanNumber = _loanNumberController.text.trim();
    final String curp = _curpController.text.trim().toUpperCase();
    if (loanNumber.isEmpty && curp.isEmpty) {
      _showMessage('Captura el CURP o el número de préstamo.');
      return;
    }

    setState(() => _isSearching = true);
    try {
      final CustomerLookupResult customer;
      if (widget.lookupCustomer != null) {
        customer = await widget.lookupCustomer!(
          loanNumber: loanNumber,
          curp: curp,
        );
      } else {
        final AuthSession? session = ref.read(authControllerProvider).whenOrNull(
              data: (AuthSession? value) => value,
            );
        if (session == null) {
          throw const CustomerLookupException(
            'La sesión no está disponible. Inicia sesión nuevamente.',
          );
        }
        customer = await ref.read(customerLookupRepositoryProvider).search(
              loanNumber: loanNumber,
              curp: curp,
              token: session.token,
            );
      }
      if (!mounted) {
        return;
      }

      _nameController.text = customer.fullName;
      final bool shouldContinue = await _confirmCustomer(customer);
      if (!shouldContinue || !mounted) {
        return;
      }

      if (widget.onCustomerSelected != null) {
        widget.onCustomerSelected!(customer);
        return;
      }
      context.go(
        '/new-credit',
        extra: LoanSearchNavigationData(
          applicationType: widget.applicationType,
          customer: customer,
        ),
      );
    } on CustomerLookupException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } on Object {
      if (mounted) {
        _showMessage('No fue posible buscar al cliente.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Future<bool> _confirmCustomer(CustomerLookupResult customer) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Cliente encontrado'),
              content: Text(
                'Se encontró al cliente ${customer.fullName} '
                '¿desea continuar con la captura del crédito?',
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
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SearchFields extends StatelessWidget {
  const _SearchFields({
    required this.loanNumberController,
    required this.curpController,
    required this.nameController,
  });

  final TextEditingController loanNumberController;
  final TextEditingController curpController;
  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const double spacing = 16;
        final double fieldWidth = constraints.maxWidth >= 700
            ? (constraints.maxWidth - spacing) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: <Widget>[
            SizedBox(
              width: fieldWidth,
              child: TextFormField(
                key: const Key('loan-number-field'),
                controller: loanNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: 'Número de préstamo',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: TextFormField(
                key: const Key('loan-curp-field'),
                controller: curpController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'CURP',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: TextFormField(
                key: const Key('loan-name-field'),
                controller: nameController,
                readOnly: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
