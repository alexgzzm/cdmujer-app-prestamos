abstract final class ApiConfig {
  static final Uri authEndpoint = Uri.parse('https://localhost:7127/api/auth');
  static final Uri attachmentsEndpoint =
      Uri.parse('https://localhost:7127/api/Attachments');
  static final Uri ineExtractionEndpoint =
      Uri.parse('https://localhost:7127/api/Customers/ExtractDataFromIne');
  static final Uri routesEndpoint =
      Uri.parse('https://localhost:7127/api/Routes');
  static final Uri groupsEndpoint =
      Uri.parse('https://localhost:7127/api/Groups');
  static final Uri statesEndpoint =
      Uri.parse('https://localhost:7127/api/Locations/GetStates');
  static final Uri citiesEndpoint =
      Uri.parse('https://localhost:7127/api/Locations/GetCities');
  static final Uri validateLoanInformationEndpoint =
      Uri.parse('https://localhost:7127/api/Loans/ValidateInformation');
  static final Uri loansEndpoint =
      Uri.parse('https://localhost:7127/api/Loans');
}
