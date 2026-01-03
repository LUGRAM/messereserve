// lib/features/payments/pages/payment_form_page.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/primary_button_loading.dart';
import '../../../app/router/routes.dart';
import '../services/payment_api.dart';

class PaymentFormPage extends StatefulWidget {
  const PaymentFormPage({super.key});

  @override
  State<PaymentFormPage> createState() => _PaymentFormPageState();
}

class _PaymentFormPageState extends State<PaymentFormPage>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  int _selectedOperator = 0; // 0: Airtel, 1: Moov
  bool _saveForLater = false;
  bool _isLoading = false;
  Timer? _paymentTimer;
  static const int _maxAttempts = 36;

  late final String commandeId;

  @override
  void initState() {
    super.initState();
    commandeId = Get.parameters['id']!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gradientTop,
                  AppColors.gradientBottom,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: Get.back,
              ),
              const Center(
                child: Text(
                  "Réglez votre messe en toute sécurité",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Entrez les informations ci-dessous pour finaliser votre réservation.",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 30),

              // ---------------- FORM CARD ----------------
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Choix de l'opérateur"),
                      const SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            _buildOperatorTab(
                              "airtel",
                              isActive: _selectedOperator == 0,
                              onTap: () =>
                                  setState(() => _selectedOperator = 0),
                            ),
                            _buildOperatorTab(
                              "moov",
                              isActive: _selectedOperator == 1,
                              onTap: () =>
                                  setState(() => _selectedOperator = 1),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      _buildLabel("Numéro Mobile Money"),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          color: Colors.black
                        ),
                        decoration: InputDecoration(
                          hintText: "07xxxxx",
                          hintStyle: TextStyle(
                            color: Colors.black54
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ---------------- ACTIONS ----------------
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: Get.back,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Annuler",
                        style: TextStyle(
                            color: Colors.black54, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButtonLoading(
                      label: "Payer maintenant",
                      onPressed: _isLoading ? null : _handlePayment,
                      loading: _isLoading,
                    ),
                  ),
                ],
              ),
            ], ///// voici
              ),
            ),
          ),
        );
      },
    )));
  }

  // ----------------------------------------------------------

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  Widget _buildOperatorTab(
      String operatorAsset, {
        required bool isActive,
        required VoidCallback onTap,
      }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? const Border(
                bottom: BorderSide(color: Color(0xff5722), width: 2))
                : null,
          ),
          child: Center(
            child: Image.asset(
              'assets/icons/$operatorAsset.jpg',
              height: 30,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
              const Icon(Icons.image_not_supported, size: 30),
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------

  Future<void> _handlePayment() async {
    if (_phoneController.text.trim().length < 8) {
      Get.snackbar(
        "Numéro invalide",
        "Veuillez saisir un numéro Mobile Money valide",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final String paymentMethod =
    _selectedOperator == 0 ? 'AM' : 'MC';

    setState(() => _isLoading = true);
    final payment = PaymentApi();

    // INITIER LE PAIEMENT
    final response = await payment.pay(
      commandeId: commandeId,
      method: paymentMethod,
      phone: _phoneController.text.trim(),
    );

    print("=============Data==============");
    print(response);
    // if (response['status'] == null &&
    //     response['status'] is String &&
    //     response['status'].toString().trim().isEmpty) {
    //   throw response['message'] ?? "Erreur lors de l'initialisation du paiement";
    // }

    // Vérification de la clé
    if (!response.containsKey('reference') || response['reference'] == null) {
      throw Exception("Référence de paiement introuvable");
    }

    final String reference = response['reference'];

    print("===============Ceci est la reference===============");
    print(reference);

    // LANCER LA VÉRIFICATION DU STATUT
    _startPaymentCheck(reference);
  }

  void _startPaymentCheck(String reference) {
    int attempts = 0;

    _paymentTimer?.cancel();
    var payment = PaymentApi();

    _paymentTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      attempts++;

      final Map<String, dynamic> result =
      await payment.check(reference);

      final String? status = result['status']?.toString();

      print("===========Statut dant le start payment==========");
      print(status);

      if (status == 'PAYED') {
        timer.cancel();
        setState(() => _isLoading = false);
        _showSuccessDialog();
        return;
      }

      if (status == 'FAILED') {
        timer.cancel();
        setState(() => _isLoading = false);
        Get.snackbar(
          "Paiement échoué",
          "La transaction a été refusée ou annulée",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // ⏱️ Timeout
      if (attempts >= _maxAttempts) {
        timer.cancel();
        setState(() => _isLoading = false);
        Get.snackbar(
          "Paiement en attente",
          "La confirmation du paiement prend trop de temps. Veuillez réessayer.",
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      // try {
      //
      //
      // } catch (e) {
      //   timer.cancel();
      //   setState(() => _isLoading = false);
      //   Get.snackbar(
      //     "Erreur",
      //     "Impossible de vérifier le statut du paiement",
      //     snackPosition: SnackPosition.BOTTOM,
      //   );
      // }
    });
  }


  void _showSuccessDialog() {
    late final AnimationController controller;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Lottie.asset(
              'assets/lottie/success.json',
              height: 100,
              controller: controller = AnimationController(vsync: this),
              onLoaded: (composition) {
                controller
                  ..duration = composition.duration
                  ..repeat();
              },
            ),
            const SizedBox(height: 8),
            const Text(
              "Paiement confirmé",
              textAlign: TextAlign.center,
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            ),
          ],
        ),
        content: const Text(
          "Merci pour votre contribution.\nVous recevrez un SMS de confirmation dans un instant.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              controller.dispose();
              Get.offAllNamed(Routes.home);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navActive,
            ),
            icon: const Padding(padding: EdgeInsets.symmetric(horizontal: 5), child: Icon(Icons.home),),
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text("Retour à l'accueil"),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
