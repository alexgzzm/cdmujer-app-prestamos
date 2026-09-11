class LoanPersonData {
  const LoanPersonData({
    required this.id,
    required this.lastname,
    required this.surname,
    required this.name,
    required this.birthDate,
    required this.gender,
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
  final int gender;
  final String street;
  final String betweenStreets;
  final String extNum;
  final String intNum;
  final String suburb;
  final int city;
  final int state;
  final String zipCode;
  final String phoneNumber;
  final int maritalStatus;
  final String curp;
}

class LoanCreationData {
  const LoanCreationData({
    required this.idRoute,
    required this.idGroup,
    required this.client,
    required this.cosigner,
    required this.date,
    required this.ammount,
    required this.term,
    required this.firstPaymentDate,
    required this.beneficiary,
    required this.relationship,
    required this.comments,
    required this.attachments,
  });

  final int idRoute;
  final int idGroup;
  final LoanPersonData client;
  final LoanPersonData cosigner;
  final DateTime date;
  final double ammount;
  final int term;
  final DateTime firstPaymentDate;
  final String beneficiary;
  final String relationship;
  final String comments;
  final List<int> attachments;
}

class LoanCreationResult {
  const LoanCreationResult({
    required this.id,
    required this.status,
    required this.message,
    required this.messageType,
  });

  final int? id;
  final bool status;
  final String message;
  final String messageType;
}
