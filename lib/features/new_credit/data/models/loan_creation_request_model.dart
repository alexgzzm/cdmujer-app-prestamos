import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_creation.dart';

class LoanCreationRequestModel {
  const LoanCreationRequestModel(this.data);

  final LoanCreationData data;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': 0,
      'type': data.type,
      'idRoute': data.idRoute,
      'idGroup': data.idGroup,
      'client': _personToJson(data.client),
      'cosigner': _personToJson(data.cosigner),
      'date': data.date.toUtc().toIso8601String(),
      'ammount': data.ammount,
      'term': data.term,
      'firstPaymentDate': data.firstPaymentDate.toUtc().toIso8601String(),
      'beneficiary': data.beneficiary,
      'relationship': data.relationship,
      'comments': data.comments,
      'attachments': data.attachments,
    };
  }

  Map<String, dynamic> _personToJson(LoanPersonData person) {
    return <String, dynamic>{
      'id': person.id,
      'lastname': person.lastname,
      'surname': person.surname,
      'name': person.name,
      'birthDate': _formatBirthDate(person.birthDate),
      'street': person.street,
      'betweenStreets': person.betweenStreets,
      'extNum': person.extNum,
      'intNum': person.intNum,
      'suburb': person.suburb,
      'city': person.city,
      'state': person.state,
      'zipCode': person.zipCode,
      'phoneNumber': person.phoneNumber,
      'maritalStatus': person.maritalStatus,
      'curp': person.curp,
    };
  }

  String _formatBirthDate(DateTime birthDate) {
    final String month = birthDate.month.toString().padLeft(2, '0');
    final String day = birthDate.day.toString().padLeft(2, '0');
    return '${birthDate.year}-$month-$day';
  }
}
