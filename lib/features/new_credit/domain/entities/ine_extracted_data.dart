class IneExtractedData {
  const IneExtractedData({
    this.lastname,
    this.surname,
    this.name,
    this.street,
    this.suburb,
    this.zipCode,
    this.curp,
  });

  final String? lastname;
  final String? surname;
  final String? name;
  final String? street;
  final String? suburb;
  final String? zipCode;
  final String? curp;

  bool get hasValues =>
      lastname != null ||
      surname != null ||
      name != null ||
      street != null ||
      suburb != null ||
      zipCode != null ||
      curp != null;
}
