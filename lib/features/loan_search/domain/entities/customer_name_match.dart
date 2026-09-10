class CustomerNameMatch {
  const CustomerNameMatch({
    required this.id,
    required this.name,
    required this.curp,
    required this.lastLoan,
    required this.loanRoute,
    required this.loanGroup,
  });

  final int id;
  final String name;
  final String curp;
  final String lastLoan;
  final String loanRoute;
  final String loanGroup;

  bool get hasLoanInformation =>
      lastLoan.isNotEmpty || loanRoute.isNotEmpty || loanGroup.isNotEmpty;
}
