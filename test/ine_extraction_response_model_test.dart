import 'package:cdmujer_app_prestamos/features/new_credit/data/models/ine_extraction_response_model.dart';
import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/ine_extracted_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps the INE endpoint response to form field names', () {
    final IneExtractionResponseModel result =
        IneExtractionResponseModel.fromJson(<String, dynamic>{
      'apellidoPaterno': 'GONZALEZ',
      'apellidoMaterno': 'MARTINEZ',
      'nombres': 'ERICK ALEJANDRO',
      'calle': 'C KANDA 315',
      'colonia': 'FRACC PRIVADA MASAI',
      'codigoPostal': '67205',
      'curp': 'GOME940127HNLNRRO9',
    });

    final IneExtractedData data = result.toEntity();
    expect(data.lastname, 'GONZALEZ');
    expect(data.surname, 'MARTINEZ');
    expect(data.name, 'ERICK ALEJANDRO');
    expect(data.street, 'C KANDA 315');
    expect(data.suburb, 'FRACC PRIVADA MASAI');
    expect(data.zipCode, '67205');
    expect(data.curp, 'GOME940127HNLNRRO9');
  });

  test('maps CURP without depending on JSON key capitalization', () {
    final IneExtractionResponseModel result =
        IneExtractionResponseModel.fromJson(<String, dynamic>{
      'CURP': 'GOME940127HNLNRRO9',
    });

    expect(result.toEntity().curp, 'GOME940127HNLNRRO9');
  });

  test('finds CURP in the complete response even when it is nested', () {
    final IneExtractionResponseModel result =
        IneExtractionResponseModel.fromJson(<String, dynamic>{
      'data': <String, dynamic>{
        'nombres': 'ERICK ALEJANDRO',
      },
      'document': <String, dynamic>{
        'curp': 'GOME940127HNLNRRO9',
      },
    });

    expect(result.toEntity().name, 'ERICK ALEJANDRO');
    expect(result.toEntity().curp, 'GOME940127HNLNRRO9');
  });

  test('recognizes a valid CURP value if the service changes its key', () {
    final IneExtractionResponseModel result =
        IneExtractionResponseModel.fromJson(<String, dynamic>{
      'data': <String, dynamic>{
        'identificadorPersonal': 'GOME940127HNLNRRO9',
      },
    });

    expect(result.toEntity().curp, 'GOME940127HNLNRRO9');
  });
}
