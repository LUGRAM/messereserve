import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentChoicePage extends StatefulWidget {
  const PaymentChoicePage({super.key});

  @override
  State<PaymentChoicePage> createState() => _PaymentChoicePageState();
}

class _PaymentChoicePageState extends State<PaymentChoicePage> {
  String? operatorSelected;
  final _phoneCtrl = TextEditingController();

  bool _loading = false;

  void _simulatePayment() async {
    if (operatorSelected == null || _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Remplissez toutes les informations")),
      );
      return;
    }

    setState(() => _loading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => _loading = false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Paiement réussi"),
        content: Lottie.asset(
          "assets/lottie/church_glow.json",
          width: 120,
          height: 120,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paiement Mobile Money"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Text(
              "Choisissez l'opérateur",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _operatorButton("Airtel", Colors.red),
                _operatorButton("Moov", Colors.blue),
              ],
            ),

            const SizedBox(height: 30),

            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Numéro Mobile Money",
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            _loading
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                icon: const Icon(Icons.lock),
                onPressed: _simulatePayment,
                label: const Text(
                  "Payer maintenant",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _operatorButton(String name, Color color) {
    final isSelected = operatorSelected == name;

    return GestureDetector(
      onTap: () => setState(() => operatorSelected = name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? color : Colors.grey),
          color: isSelected ? color.withValues(alpha: .15) : Colors.white,
        ),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isSelected ? color : Colors.black,
          ),
        ),
      ),
    );
  }
}
