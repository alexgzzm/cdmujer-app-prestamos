import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/entities/customer_name_match.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/domain/errors/customer_lookup_exception.dart';
import 'package:cdmujer_app_prestamos/features/loan_search/presentation/providers/customer_lookup_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

typedef CosignerNameLookupCallback = Future<List<CustomerNameMatch>> Function({
  required String name,
  required String lastname,
  required String surname,
});

class CosignerSearchPage extends ConsumerStatefulWidget {
  const CosignerSearchPage({
    this.lookupCustomersByName,
    super.key,
  });

  final CosignerNameLookupCallback? lookupCustomersByName;

  @override
  ConsumerState<CosignerSearchPage> createState() =>
      _CosignerSearchPageState();
}

class _CosignerSearchPageState extends ConsumerState<CosignerSearchPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  List<CustomerNameMatch> _matches = const <CustomerNameMatch>[];
  CustomerNameMatch? _selectedMatch;
  bool _isSearching = false;

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: const Key('return-to-cosigner-form-button'),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/new-credit');
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Regresar a la captura del aval'),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Buscar aval',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Captura el nombre completo para buscar coincidencias.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      _CosignerSearchFields(
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
                            key: const Key('cosigner-search-submit-button'),
                            onPressed: _isSearching ? null : _search,
                            icon: _isSearching
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.search),
                            label: Text(
                              _isSearching ? 'Buscando...' : 'Buscar',
                            ),
                          ),
                        ),
                      ),
                      if (_matches.isNotEmpty) ...<Widget>[
                        const SizedBox(height: 32),
                        Text(
                          'Personas encontradas',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        _CosignerMatches(
                          matches: _matches,
                          selectedMatch: _selectedMatch,
                          onSelected: (CustomerNameMatch match) {
                            setState(() => _selectedMatch = match);
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _search() async {
    final String name = _nameController.text.trim().toUpperCase();
    final String lastname = _lastnameController.text.trim().toUpperCase();
    final String surname = _surnameController.text.trim().toUpperCase();
    if (name.isEmpty && lastname.isEmpty && surname.isEmpty) {
      _showMessage('Captura el nombre completo del aval.');
      return;
    }
    if (name.isEmpty || lastname.isEmpty || surname.isEmpty) {
      _showMessage(
        'Para buscar por nombre, captura nombres, apellido paterno y apellido materno.',
      );
      return;
    }

    setState(() {
      _isSearching = true;
      _matches = const <CustomerNameMatch>[];
      _selectedMatch = null;
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
        _showMessage('No fue posible buscar avales por nombre.');
      }
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
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

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CosignerSearchFields extends StatelessWidget {
  const _CosignerSearchFields({
    required this.nameController,
    required this.lastnameController,
    required this.surnameController,
  });

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
            _field(
              width: fieldWidth,
              key: const Key('cosigner-name-field'),
              controller: nameController,
              label: 'Nombres',
            ),
            _field(
              width: fieldWidth,
              key: const Key('cosigner-lastname-field'),
              controller: lastnameController,
              label: 'Apellido paterno',
            ),
            _field(
              width: fieldWidth,
              key: const Key('cosigner-surname-field'),
              controller: surnameController,
              label: 'Apellido materno',
            ),
          ],
        );
      },
    );
  }

  Widget _field({
    required double width,
    required Key key,
    required TextEditingController controller,
    required String label,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        key: key,
        controller: controller,
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _CosignerMatches extends StatelessWidget {
  const _CosignerMatches({
    required this.matches,
    required this.selectedMatch,
    required this.onSelected,
  });

  final List<CustomerNameMatch> matches;
  final CustomerNameMatch? selectedMatch;
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
        final bool isSelected = selectedMatch?.id == customer.id;
        return Card.outlined(
          key: Key('cosigner-match-${customer.id}'),
          margin: EdgeInsets.zero,
          color: isSelected
              ? Theme.of(context).colorScheme.secondaryContainer
              : null,
          child: InkWell(
            onTap: () => onSelected(customer),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      isSelected ? Icons.check_circle : Icons.person_outline,
                      key: isSelected
                          ? Key('selected-cosigner-${customer.id}')
                          : null,
                    ),
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
                  Text(isSelected ? 'Seleccionado' : 'Seleccionar'),
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
