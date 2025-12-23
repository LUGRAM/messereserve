// features/payments/models/transaction_model.dart

class TransactionModel {
  final String reference;
  final String massTitle;
  final String date;
  final String time;
  final String operator;
  final double amount;
  final String status; // "success", "failed"

  TransactionModel({
    required this.reference,
    required this.massTitle,
    required this.date,
    required this.time,
    required this.operator,
    required this.amount,
    required this.status,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      reference: json['reference'],
      massTitle: json['mass_title'],
      date: json['date'],
      time: json['time'],
      operator: json['operator'],
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference,
      'mass_title': massTitle,
      'date': date,
      'time': time,
      'operator': operator,
      'amount': amount,
      'status': status,
    };
  }
}
