import 'package:cdmujer_app_prestamos/features/new_credit/data/models/ine_extraction_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps wrapped INE data to form field names', () {
    final IneExtractionResponseModel result =
        IneExtractionResponseModel.fromJson(<String, dynamic>{
      'status': true,
      'data': <String, dynamic>{
        'nombre': 'ANA',
        'apellidoPaterno': 'LÓPEZ',
        'apellidoMaterno': 'PÉREZ',
        'direccion': <String, dynamic>{
          'calle': 'REFORMA',
          'colonia': 'CENTRO',
          'codigoPostal': '06000',
        },
      },
    });

    expect(result.values['name'], 'ANA');
    expect(result.values['lastname'], 'LÓPEZ');
    expect(result.values['surname'], 'PÉREZ');
    expect(result.values['street'], 'REFORMA');
    expect(result.values['suburb'], 'CENTRO');
    expect(result.values['zipCode'], '06000');
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
