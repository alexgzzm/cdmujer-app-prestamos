import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_lookup_result.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_name_match.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/errors/customer_lookup_exception.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/presentation/providers/customer_lookup_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_information_validation.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/loan_information_validation_exception.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/providers/loan_information_validation_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

typedef CustomerLookupCallback = Future<CustomerLookupResult> Function({
  required String loanNumber,
  required String curp,
});

typedef CustomerNameLookupCallback = Future<List<CustomerNameMatch>> Function({
  required String name,
  required String lastname,
  required String surname,
});

typedef CustomerValidationCallback = Future<LoanInformationValidation>
    Function({required String curp});

class LoanSearchPage extends ConsumerStatefulWidget {
  const LoanSearchPage({
    required this.applicationType,
    this.lookupCustomer,
    this.lookupCustomersByName,
    this.validateCustomer,
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
  final CustomerNameLookupCallback? lookupCustomersByName;
  final CustomerValidationCallback? validateCustomer;
  final ValueChanged<CustomerLookupResult>? onCustomerSelected;

  @override
  ConsumerState<LoanSearchPage> createState() => _LoanSearchPageState();
}

class _LoanSearchPageState extends ConsumerState<LoanSearchPage> {
  final TextEditingController _loanNumberController = TextEditingController();
  final TextEditingController _curpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  List<CustomerNameMatch> _matches = const <CustomerNameMatch>[];
  bool _isSearching = false;

  @override
  void dispose() {
    _loanNumberController.dispose();
    _curpController.dispose();
    _nameController.dispose();
    _lastnameController.dispose();
    _surnameController.dispose();
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
                    'Busca por número de préstamo, CURP o nombre completo.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  _SearchFields(
                    loanNumberController: _loanNumberController,
                    curpController: _curpController,
                    nameController: _nameController,
                    lastnameController: _lastnameController,
                    surnameController: _surnameController,
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
                  if (_matches.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 32),
                    Text(
                      'Clientes encontrados',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _CustomerMatches(
                      matches: _matches,
                      isSearching: _isSearching,
                      onSelected: _selectNameMatch,
                    ),
                  ],
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
    if (loanNumber.isNotEmpty || curp.isNotEmpty) {
      await _searchExactCustomer(loanNumber: loanNumber, curp: curp);
      return;
    }

    final String name = _nameController.text.trim().toUpperCase();
    final String lastname = _lastnameController.text.trim().toUpperCase();
    final String surname = _surnameController.text.trim().toUpperCase();
    if (name.isEmpty && lastname.isEmpty && surname.isEmpty) {
      _showMessage(
        'Captura el CURP, el número de préstamo o el nombre completo.',
      );
      return;
    }
    if (name.isEmpty || lastname.isEmpty || surname.isEmpty) {
      _showMessage(
        'Para buscar por nombre, captura nombres, apellido paterno y apellido materno.',
      );
      return;
    }

    await _searchCustomersByName(
      name: name,
      lastname: lastname,
      surname: surname,
    );
  }

  Future<void> _searchExactCustomer({
    required String loanNumber,
    required String curp,
    bool clearMatches = true,
  }) async {
    setState(() {
      _isSearching = true;
      if (clearMatches) {
        _matches = const <CustomerNameMatch>[];
      }
    });
    try {
      final CustomerLookupResult customer = await _lookupExactCustomer(
        loanNumber: loanNumber,
        curp: curp,
      );
      if (!mounted) {
        return;
      }

      _nameController.text = customer.name;
      _lastnameController.text = customer.lastname;
      _surnameController.text = customer.surname;
      final bool canContinue = await _validateCustomer(customer.curp);
      if (!canContinue || !mounted) {
        return;
      }
      await _continueWithCustomer(customer);
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

  Future<void> _searchCustomersByName({
    required String name,
    required String lastname,
    required String surname,
  }) async {
    setState(() {
      _isSearching = true;
      _matches = const <CustomerNameMatch>[];
    });
    try {
      final List<CustomerNameMatch> matches;
      if (widget.lookupCustomersByName != null) {
        matches = await widget.lookupCustomersByName!(
          name: name,
          lastname: lastname,
          surname: surname,
        );
      } else {
        final AuthSession session = _requireSession();
        matches = await ref
            .read(customerLookupRepositoryProvider)
            .searchByName(
              name: name,
              lastname: lastname,
              surname: surname,
              token: session.token,
            );
      }
      if (!mounted) {
        return;
      }
      setState(() => _matches = matches);
      if (matches.isEmpty) {
        _showMessage('No se encontraron clientes con ese nombre completo.');
      }
    } on CustomerLookupException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } on Object {
      if (mounted) {
        _showMessage('No fue posible buscar clientes por nombre.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Future<CustomerLookupResult> _lookupExactCustomer({
    required String loanNumber,
    required String curp,
  }) async {
    if (widget.lookupCustomer != null) {
      return widget.lookupCustomer!(loanNumber: loanNumber, curp: curp);
    }
    final AuthSession session = _requireSession();
    return ref.read(customerLookupRepositoryProvider).search(
          loanNumber: loanNumber,
          curp: curp,
          token: session.token,
        );
  }

  AuthSession _requireSession() {
    final AuthSession? session = ref.read(authControllerProvider).whenOrNull(
          data: (AuthSession? value) => value,
        );
    if (session == null) {
      throw const CustomerLookupException(
        'La sesión no está disponible. Inicia sesión nuevamente.',
      );
    }
    return session;
  }

  Future<bool> _validateCustomer(String curp) async {
    final String normalizedCurp = curp.trim().toUpperCase();
    try {
      final LoanInformationValidation validation;
      if (widget.validateCustomer != null) {
        validation = await widget.validateCustomer!(curp: normalizedCurp);
      } else {
        final AuthSession? session =
            ref.read(authControllerProvider).whenOrNull(
                  data: (AuthSession? value) => value,
                );
        if (session == null) {
          throw const LoanInformationValidationException(
            'La sesión no está disponible. Inicia sesión nuevamente.',
          );
        }
        validation = await ref
            .read(loanInformationValidationRepositoryProvider)
            .validate(curp: normalizedCurp, token: session.token);
      }
      if (!mounted || !validation.shouldShowMessage) {
        return mounted;
      }

      await _showCustomerValidationDialog(
        message: validation.message,
        mustReturnHome: validation.mustReturnHome,
      );
      return mounted && !validation.mustReturnHome;
    } on LoanInformationValidationException catch (error) {
      if (mounted) {
        await _showCustomerValidationDialog(
          message: error.message,
          mustReturnHome: false,
        );
      }
      return mounted;
    } on Object {
      if (mounted) {
        await _showCustomerValidationDialog(
          message: 'No fue posible validar la información del CURP.',
          mustReturnHome: false,
        );
      }
      return mounted;
    }
  }

  Future<void> _showCustomerValidationDialog({
    required String message,
    required bool mustReturnHome,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: !mustReturnHome,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            mustReturnHome ? 'No es posible continuar' : 'Advertencia',
          ),
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
    if (mustReturnHome && mounted) {
      context.go('/home');
    }
  }

  Future<void> _selectNameMatch(CustomerNameMatch match) async {
    _curpController.text = match.curp;
    await _searchExactCustomer(
      loanNumber: '',
      curp: match.curp,
      clearMatches: false,
    );
  }

  Future<void> _continueWithCustomer(CustomerLookupResult customer) async {
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
    required this.lastnameController,
    required this.surnameController,
  });

  final TextEditingController loanNumberController;
  final TextEditingController curpController;
  final TextEditingController nameController;
  final TextEditingController lastnameController;
  final TextEditingController surnameController;

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
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nombres',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: TextFormField(
                key: const Key('loan-lastname-field'),
                controller: lastnameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Apellido paterno',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: fieldWidth,
              child: TextFormField(
                key: const Key('loan-surname-field'),
                controller: surnameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Apellido materno',
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

class _CustomerMatches extends StatelessWidget {
  const _CustomerMatches({
    required this.matches,
    required this.isSearching,
    required this.onSelected,
  });

  final List<CustomerNameMatch> matches;
  final bool isSearching;
  final ValueChanged<CustomerNameMatch> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: matches.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final CustomerNameMatch customer = matches[index];
        return Card.outlined(
          key: Key('customer-match-${customer.id}'),
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: isSearching ? null : () => onSelected(customer),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(Icons.person_outline),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          customer.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text('CURP: ${customer.curp}'),
                        if (customer.hasLoanInformation) ...<Widget>[
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 16,
                            runSpacing: 4,
                            children: <Widget>[
                              if (customer.lastLoan.isNotEmpty)
                                Text(
                                  'Último préstamo: ${customer.lastLoan}',
                                  style: _metadataStyle(context),
                                ),
                              if (customer.loanRoute.isNotEmpty)
                                Text(
                                  'Ruta: ${customer.loanRoute}',
                                  style: _metadataStyle(context),
                                ),
                              if (customer.loanGroup.isNotEmpty)
                                Text(
                                  'Grupo: ${customer.loanGroup}',
                                  style: _metadataStyle(context),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TextStyle? _metadataStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
  }
}
