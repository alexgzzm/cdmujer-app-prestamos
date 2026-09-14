abstract final class ApiConfig {
  static const String environment = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'dev',
  );

  static final String baseUrl = switch (environment.toLowerCase()) {
    'dev' => 'https://localhost:7127',
    'qa' => 'https://cdmujer-api-dsfugwdqb2efdjf2.westus3-01.azurewebsites.net',
    _ => throw UnsupportedError(
        'Ambiente no soportado: $environment. Usa dev o qa.',
      ),
  };

  static Uri _endpoint(String path) => Uri.parse('$baseUrl$path');

  static final Uri authEndpoint = _endpoint('/api/auth');
  static final Uri attachmentsEndpoint = _endpoint('/api/Attachments');
  static final Uri ineExtractionEndpoint =
      _endpoint('/api/Customers/ExtractDataFromIne');
  static final Uri routesEndpoint = _endpoint('/api/Routes');
  static final Uri groupsEndpoint = _endpoint('/api/Groups');
  static final Uri statesEndpoint = _endpoint('/api/Locations/GetStates');
  static final Uri citiesEndpoint = _endpoint('/api/Locations/GetCities');
  static final Uri relationshipsEndpoint =
      _endpoint('/api/Catalogs/GetRelationships');
  static final Uri maritalStatusesEndpoint =
      _endpoint('/api/Catalogs/GetMaritalStatus');
  static final Uri validateLoanInformationEndpoint =
      _endpoint('/api/Loans/ValidateInformation');
  static final Uri loansEndpoint = _endpoint('/api/Loans');
  static final Uri loanBalanceEndpoint = _endpoint('/api/Loans/GetBalance');
  static final Uri customerFromLoanOrCurpEndpoint =
      _endpoint('/api/Customers/GetCustomerFromLoanOrCurp');
  static final Uri customersByNameEndpoint =
      _endpoint('/api/Customers/SearchCustomersByName');
  static final Uri customerByIdEndpoint = _endpoint('/api/Customers/GetById');
}
