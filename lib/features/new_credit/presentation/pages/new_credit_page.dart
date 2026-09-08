import 'package:cdmujer_app_prestamos/app/theme/app_colors.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/responsive_form_fields.dart';
import 'package:flutter/material.dart';

class NewCreditPage extends StatefulWidget {
  const NewCreditPage({super.key});

  @override
  State<NewCreditPage> createState() => _NewCreditPageState();
}

class _NewCreditPageState extends State<NewCreditPage> {
  static const List<String> _stepTitles = <String>[
    'Datos del cliente',
    'Datos del aval',
    'Información del crédito',
  ];

  static const List<CreditFieldDefinition> _personFields =
      <CreditFieldDefinition>[
    CreditFieldDefinition(
      name: 'id',
      label: 'ID',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(
      name: 'client',
      label: 'Número de cliente',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(name: 'lastname', label: 'Apellido paterno'),
    CreditFieldDefinition(name: 'surname', label: 'Apellido materno'),
    CreditFieldDefinition(name: 'name', label: 'Nombre'),
    CreditFieldDefinition(
      name: 'gender',
      label: 'Género',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(name: 'street', label: 'Calle'),
    CreditFieldDefinition(name: 'betweenStreets', label: 'Entre calles'),
    CreditFieldDefinition(name: 'extNum', label: 'Número exterior'),
    CreditFieldDefinition(name: 'intNum', label: 'Número interior'),
    CreditFieldDefinition(name: 'suburb', label: 'Colonia'),
    CreditFieldDefinition(
      name: 'city',
      label: 'Ciudad',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(
      name: 'state',
      label: 'Estado',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(
      name: 'zipCode',
      label: 'Código postal',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(
      name: 'phoneNumber',
      label: 'Teléfono',
      keyboardType: TextInputType.phone,
    ),
    CreditFieldDefinition(
      name: 'phoneNumber2',
      label: 'Teléfono secundario',
      keyboardType: TextInputType.phone,
    ),
    CreditFieldDefinition(
      name: 'mobileNumber',
      label: 'Celular',
      keyboardType: TextInputType.phone,
    ),
    CreditFieldDefinition(
      name: 'mobileNumber2',
      label: 'Celular secundario',
      keyboardType: TextInputType.phone,
    ),
    CreditFieldDefinition(
      name: 'maritalStatus',
      label: 'Estado civil',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(name: 'rfc', label: 'RFC'),
    CreditFieldDefinition(name: 'curp', label: 'CURP'),
    CreditFieldDefinition(name: 'ine', label: 'INE'),
    CreditFieldDefinition(name: 'passport', label: 'Pasaporte'),
    CreditFieldDefinition(name: 'originCountry', label: 'País de origen'),
  ];

  static const List<CreditFieldDefinition> _creditFields =
      <CreditFieldDefinition>[
    CreditFieldDefinition(
      name: 'id',
      label: 'ID',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(
      name: 'idRoute',
      label: 'Ruta',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(
      name: 'idGroup',
      label: 'Grupo',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(
      name: 'date',
      label: 'Fecha',
      keyboardType: TextInputType.datetime,
    ),
    CreditFieldDefinition(
      name: 'ammount',
      label: 'Monto',
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    ),
    CreditFieldDefinition(
      name: 'paymentMethod',
      label: 'Método de pago',
      keyboardType: TextInputType.number,
    ),
    CreditFieldDefinition(
      name: 'firstPaymentDate',
      label: 'Fecha del primer pago',
      keyboardType: TextInputType.datetime,
    ),
    CreditFieldDefinition(
      name: 'globalInterest',
      label: 'Interés global',
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    ),
    CreditFieldDefinition(
      name: 'iva',
      label: 'IVA',
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    ),
    CreditFieldDefinition(
      name: 'insurance',
      label: 'Seguro',
      keyboardType: TextInputType.numberWithOptions(decimal: true),
    ),
    CreditFieldDefinition(name: 'beneficiary', label: 'Beneficiario'),
    CreditFieldDefinition(name: 'relationship', label: 'Parentesco'),
    CreditFieldDefinition(
      name: 'comments',
      label: 'Comentarios',
      maxLines: 3,
    ),
  ];

  late final Map<String, TextEditingController> _clientControllers;
  late final Map<String, TextEditingController> _cosignerControllers;
  late final Map<String, TextEditingController> _creditControllers;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _clientControllers = _createControllers(_personFields);
    _cosignerControllers = _createControllers(_personFields);
    _creditControllers = _createControllers(_creditFields);
  }

  @override
  void dispose() {
    for (final TextEditingController controller in <TextEditingController>[
      ..._clientControllers.values,
      ..._cosignerControllers.values,
      ..._creditControllers.values,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _WizardHeader(
          currentStep: _currentStep,
          title: _stepTitles[_currentStep],
          stepCount: _stepTitles.length,
        ),
        Expanded(
          child: IndexedStack(
            index: _currentStep,
            children: <Widget>[
              _FormStep(
                fields: _personFields,
                controllers: _clientControllers,
              ),
              _FormStep(
                fields: _personFields,
                controllers: _cosignerControllers,
              ),
              _FormStep(
                fields: _creditFields,
                controllers: _creditControllers,
              ),
            ],
          ),
        ),
        _WizardNavigation(
          currentStep: _currentStep,
          lastStep: _stepTitles.length - 1,
          onBack: _previousStep,
          onNext: _nextStep,
        ),
      ],
    );
  }

  Map<String, TextEditingController> _createControllers(
    List<CreditFieldDefinition> fields,
  ) {
    return <String, TextEditingController>{
      for (final CreditFieldDefinition field in fields)
        field.name: TextEditingController(),
    };
  }

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }
}

class _WizardHeader extends StatelessWidget {
  const _WizardHeader({
    required this.currentStep,
    required this.title,
    required this.stepCount,
  });

  final int currentStep;
  final String title;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Paso ${currentStep + 1} de $stepCount',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
              const SizedBox(height: 6),
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              LinearProgressIndicator(value: (currentStep + 1) / stepCount),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormStep extends StatelessWidget {
  const _FormStep({required this.fields, required this.controllers});

  final List<CreditFieldDefinition> fields;
  final Map<String, TextEditingController> controllers;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Form(
            child: ResponsiveFormFields(
              fields: fields,
              controllers: controllers,
            ),
          ),
        ),
      ),
    );
  }
}

class _WizardNavigation extends StatelessWidget {
  const _WizardNavigation({
    required this.currentStep,
    required this.lastStep,
    required this.onBack,
    required this.onNext,
  });

  final int currentStep;
  final int lastStep;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Row(
              children: <Widget>[
                if (currentStep > 0)
                  SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Anterior'),
                    ),
                  ),
                const Spacer(),
                if (currentStep < lastStep)
                  SizedBox(
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: onNext,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Siguiente'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
