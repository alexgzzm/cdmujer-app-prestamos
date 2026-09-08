import 'dart:typed_data';

import 'package:cdmujer_app_prestamos/features/auth/domain/entities/auth_session.dart';
import 'package:cdmujer_app_prestamos/features/auth/presentation/providers/auth_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/attachment_upload_result.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/ine_extracted_data.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/attachment_upload_exception.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/errors/ine_extraction_exception.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/providers/attachment_providers.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/identity_attachment_buttons.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/presentation/widgets/responsive_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class NewCreditPage extends ConsumerStatefulWidget {
  const NewCreditPage({super.key});

  @override
  ConsumerState<NewCreditPage> createState() => _NewCreditPageState();
}

class _NewCreditPageState extends ConsumerState<NewCreditPage> {
  static const String _clientFrontSlot = 'client-front';
  static const String _clientBackSlot = 'client-back';
  static const String _cosignerFrontSlot = 'cosigner-front';
  static const String _cosignerBackSlot = 'cosigner-back';
  static const int _ineFrontFileType = 1;
  static const int _ineBackFileType = 2;

  static const List<String> _stepTitles = <String>[
    'Datos del cliente',
    'Datos del aval',
    'Información del crédito',
  ];

  static const List<CreditFieldDefinition> _personFields =
      <CreditFieldDefinition>[
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
  final ImagePicker _imagePicker = ImagePicker();
  final List<int> _attachmentIds = <int>[];
  final Map<String, int> _attachmentIdsBySlot = <String, int>{};
  final Set<String> _uploadingSlots = <String>{};
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
                leading: IdentityAttachmentButtons(
                  onFrontPressed: () => _captureAndUpload(
                    slot: _clientFrontSlot,
                    fileType: _ineFrontFileType,
                    extractionTarget: _clientControllers,
                  ),
                  onBackPressed: () => _captureAndUpload(
                    slot: _clientBackSlot,
                    fileType: _ineBackFileType,
                  ),
                  frontUploading: _uploadingSlots.contains(_clientFrontSlot),
                  backUploading: _uploadingSlots.contains(_clientBackSlot),
                  frontUploaded:
                      _attachmentIdsBySlot.containsKey(_clientFrontSlot),
                  backUploaded:
                      _attachmentIdsBySlot.containsKey(_clientBackSlot),
                ),
              ),
              _FormStep(
                fields: _personFields,
                controllers: _cosignerControllers,
                leading: IdentityAttachmentButtons(
                  onFrontPressed: () => _captureAndUpload(
                    slot: _cosignerFrontSlot,
                    fileType: _ineFrontFileType,
                    extractionTarget: _cosignerControllers,
                  ),
                  onBackPressed: () => _captureAndUpload(
                    slot: _cosignerBackSlot,
                    fileType: _ineBackFileType,
                  ),
                  frontUploading:
                      _uploadingSlots.contains(_cosignerFrontSlot),
                  backUploading:
                      _uploadingSlots.contains(_cosignerBackSlot),
                  frontUploaded:
                      _attachmentIdsBySlot.containsKey(_cosignerFrontSlot),
                  backUploaded:
                      _attachmentIdsBySlot.containsKey(_cosignerBackSlot),
                ),
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

  Future<void> _captureAndUpload({
    required String slot,
    required int fileType,
    Map<String, TextEditingController>? extractionTarget,
  }) async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 85,
      );
      if (photo == null || !mounted) {
        return;
      }

      setState(() => _uploadingSlots.add(slot));
      final AuthSession? session = ref.read(authControllerProvider).whenOrNull(
            data: (AuthSession? value) => value,
          );
      if (session == null) {
        throw const AttachmentUploadException(
          'La sesión no está disponible. Inicia sesión nuevamente.',
        );
      }
      final Uint8List bytes = await photo.readAsBytes();

      await _uploadAttachment(
        slot: slot,
        fileType: fileType,
        bytes: bytes,
        fileName: photo.name,
        contentType: photo.mimeType,
        token: session.token,
      );
      if (extractionTarget != null) {
        await _extractIneData(
          bytes: bytes,
          fileName: photo.name,
          contentType: photo.mimeType,
          token: session.token,
          target: extractionTarget,
        );
      }
    } on AttachmentUploadException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } on Object {
      if (mounted) {
        _showMessage('No fue posible capturar o cargar la imagen.');
      }
    } finally {
      if (mounted) {
        setState(() => _uploadingSlots.remove(slot));
      }
    }
  }

  Future<void> _uploadAttachment({
    required String slot,
    required int fileType,
    required Uint8List bytes,
    required String fileName,
    required String? contentType,
    required String token,
  }) async {
    try {
      final AttachmentUploadResult result =
          await ref.read(attachmentRepositoryProvider).upload(
                bytes: bytes,
                fileName: fileName,
                contentType: contentType,
                fileType: fileType,
                token: token,
              );
      if (!mounted) {
        return;
      }
      setState(() => _storeAttachmentId(slot: slot, id: result.id));
      _showMessage(
        result.message.isEmpty
            ? 'La imagen se cargó correctamente.'
            : result.message,
      );
    } on AttachmentUploadException catch (error) {
      if (mounted) {
        _showMessage(error.message);
      }
    } on Object {
      if (mounted) {
        _showMessage('No fue posible cargar la imagen.');
      }
    }
  }

  Future<void> _extractIneData({
    required Uint8List bytes,
    required String fileName,
    required String? contentType,
    required String token,
    required Map<String, TextEditingController> target,
  }) async {
    try {
      final IneExtractedData extractedData =
          await ref.read(ineDataRepositoryProvider).extract(
                bytes: bytes,
                fileName: fileName,
                contentType: contentType,
                token: token,
              );
      if (!mounted) {
        return;
      }
      for (final MapEntry<String, String> entry
          in extractedData.values.entries) {
        final TextEditingController? controller = target[entry.key];
        if (controller != null) {
          controller.value = TextEditingValue(
            text: entry.value,
            selection: TextSelection.collapsed(offset: entry.value.length),
          );
        }
      }
    } on IneExtractionException {
      if (mounted) {
        await _showIneExtractionError();
      }
    } on Object {
      if (mounted) {
        await _showIneExtractionError();
      }
    }
  }

  Future<void> _showIneExtractionError() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Datos del INE no disponibles'),
          content: const Text(
            'En este momento no podemos obtener los datos del INE. '
            'Captura la información manualmente.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _storeAttachmentId({required String slot, required int id}) {
    final int? previousId = _attachmentIdsBySlot[slot];
    if (previousId != null) {
      _attachmentIds.remove(previousId);
    }
    _attachmentIdsBySlot[slot] = id;
    _attachmentIds.add(id);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: (currentStep + 1) / stepCount),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormStep extends StatelessWidget {
  const _FormStep({
    required this.fields,
    required this.controllers,
    this.leading,
  });

  final List<CreditFieldDefinition> fields;
  final Map<String, TextEditingController> controllers;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  leading!,
                  const SizedBox(height: 20),
                ],
                ResponsiveFormFields(
                  fields: fields,
                  controllers: controllers,
                ),
              ],
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
