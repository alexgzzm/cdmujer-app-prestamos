import 'package:cdmujer_app_prestamos/features/new_credit/domain/entities/loan_balance.dart';

class LoanBalanceModel {
  const LoanBalanceModel({required this.amount});

  factory LoanBalanceModel.fromJson(Map<String, dynamic> json) {
    final double? amount = double.tryParse(json['amount']?.toString() ?? '');
    if (amount == null || !amount.isFinite) {
      throw const FormatException(
        'La respuesta del saldo del cliente no es válida.',
      );
    }
    return LoanBalanceModel(amount: amount);
  }

  final double amount;

  LoanBalance toEntity() => LoanBalance(amount: amount);
}
