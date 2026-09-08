import 'package:http_parser/http_parser.dart';

abstract final class MultipartUtils {
  static MediaType imageContentType(String? contentType) {
    if (contentType == null || contentType.isEmpty) {
      return MediaType('image', 'jpeg');
    }
    try {
      return MediaType.parse(contentType);
    } on FormatException {
      return MediaType('image', 'jpeg');
    }
  }
}
