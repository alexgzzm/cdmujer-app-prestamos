import 'package:flutter/material.dart';

class IdentityAttachmentButtons extends StatelessWidget {
  const IdentityAttachmentButtons({
    required this.onFrontPressed,
    required this.onBackPressed,
    required this.frontUploading,
    required this.backUploading,
    required this.frontUploaded,
    required this.backUploaded,
    super.key,
  });

  final VoidCallback onFrontPressed;
  final VoidCallback onBackPressed;
  final bool frontUploading;
  final bool backUploading;
  final bool frontUploaded;
  final bool backUploaded;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        _AttachmentButton(
          label: 'INE Frontal',
          uploading: frontUploading,
          uploaded: frontUploaded,
          onPressed: onFrontPressed,
        ),
        _AttachmentButton(
          label: 'INE Reverso',
          uploading: backUploading,
          uploaded: backUploaded,
          onPressed: onBackPressed,
        ),
      ],
    );
  }
}

class _AttachmentButton extends StatelessWidget {
  const _AttachmentButton({
    required this.label,
    required this.uploading,
    required this.uploaded,
    required this.onPressed,
  });

  final String label;
  final bool uploading;
  final bool uploaded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: uploading ? null : onPressed,
      icon: uploading
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(uploaded ? Icons.check_circle_outline : Icons.photo_camera),
      label: Text(label),
    );
  }
}
