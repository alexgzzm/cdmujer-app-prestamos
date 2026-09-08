import 'package:cdmujer_app_prestamos/features/new_credit/data/models/ine_extraction_response_model.dart';
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

    expect(result.values['lastname'], 'GONZALEZ');
    expect(result.values['surname'], 'MARTINEZ');
    expect(result.values['name'], 'ERICK ALEJANDRO');
    expect(result.values['street'], 'C KANDA 315');
    expect(result.values['suburb'], 'FRACC PRIVADA MASAI');
    expect(result.values['zipCode'], '67205');
    expect(result.values['curp'], 'GOME940127HNLNRRO9');
  });

  test('maps a direct client number without treating it as a wrapper', () {
    final IneExtractionResponseModel result =
        IneExtractionResponseModel.fromJson(<String, dynamic>{
      'client': 25,
      'name': 'ANA',
    });

    expect(result.values['client'], '25');
    expect(result.values['name'], 'ANA');
  });
}
