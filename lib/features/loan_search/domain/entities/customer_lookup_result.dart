class CustomerLookupResult {
  const CustomerLookupResult({
    required this.id,
    required this.lastname,
    required this.surname,
    required this.name,
    required this.birthDate,
    required this.street,
    required this.betweenStreets,
    required this.extNum,
    required this.intNum,
    required this.suburb,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.phoneNumber,
    required this.maritalStatus,
    required this.curp,
  });

  final int id;
  final String lastname;
  final String surname;
  final String name;
  final DateTime birthDate;
  final String street;
  final String betweenStreets;
  final String extNum;
  final String intNum;
  final String suburb;
  final int city;
  final int state;
  final String zipCode;
  final String? phoneNumber;
  final int maritalStatus;
  final String curp;

  String get fullName => <String>[name, lastname, surname]
      .where((String part) => part.trim().isNotEmpty)
      .join(', ');
}

class LoanSearchNavigationData {
  const LoanSearchNavigationData({
    required this.applicationType,
    required this.customer,
  });

  final int applicationType;
  final CustomerLookupResult customer;
}
