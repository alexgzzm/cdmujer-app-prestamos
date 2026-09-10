import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoanSearchPage extends StatefulWidget {
  const LoanSearchPage({
    required this.applicationType,
    super.key,
  }) : assert(
          applicationType == renewalType || applicationType == reentryType,
          'applicationType must identify renewal or reentry.',
        );

  static const int renewalType = 2;
  static const int reentryType = 3;

  final int applicationType;

  @override
  State<LoanSearchPage> createState() => _LoanSearchPageState();
}

class _LoanSearchPageState extends State<LoanSearchPage> {
  final TextEditingController _loanNumberController = TextEditingController();
  final TextEditingController _curpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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
                        onPressed: () {},
                        icon: const Icon(Icons.search),
                        label: const Text('Buscar'),
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
