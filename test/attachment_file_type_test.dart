import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/attachment_file_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defines the attachment API file types', () {
    expect(AttachmentFileType.clientIneFront, 1);
    expect(AttachmentFileType.clientIneBack, 2);
    expect(AttachmentFileType.cosignerIneFront, 3);
    expect(AttachmentFileType.cosignerIneBack, 4);
    expect(AttachmentFileType.proof, 5);
  });
}
