import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewCreditPage extends StatefulWidget {
  const NewCreditPage({super.key});

  @override
  State<NewCreditPage> createState() => _NewCreditPageState();
}

class _NewCreditPageState extends State<NewCreditPage> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Form(
          child: Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: _captureIneFront,
              icon: const Icon(Icons.photo_camera_outlined),
              label: const Text('INE Frontal'),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _captureIneFront() async {
    await _imagePicker.pickImage(source: ImageSource.camera);
  }
}
