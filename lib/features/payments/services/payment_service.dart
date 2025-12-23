// features/payments/services/payment_service.dart

import 'dart:async';
import '../models/transaction_model.dart';

class PaymentService {
  static Future<TransactionModel> payWithMobileMoney({
    required String reference,
    required String massTitle,
    required String date,
    required String time,
    required String operator,
    required String phone,
    required double amount,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate payment delay

    // 🔁 Simulated logic (replace with real API logic)
    final isSuccess = phone.endsWith("0") == false; // simulate failure on numbers ending in 0

    return TransactionModel(
      reference: reference,
      massTitle: massTitle,
      date: date,
      time: time,
      operator: operator,
      amount: amount,
      status: isSuccess ? "success" : "failed",
    );
  }

  static Future<List<TransactionModel>> fetchTransactionHistory() async {
    await Future.delayed(const Duration(seconds: 2)); // simulate loading

    return [
      TransactionModel(
        reference: "MC-20251205-A1",
        massTitle: "Messe d'action de grâce",
        date: "05/12/2025",
        time: "10:00",
        operator: "Airtel",
        amount: 8000,
        status: "success",
      ),
      TransactionModel(
        reference: "MC-20251202-B7",
        massTitle: "Messe de requiem",
        date: "02/12/2025",
        time: "16:00",
        operator: "Moov",
        amount: 8000,
        status: "failed",
      ),
    ];
  }
}
