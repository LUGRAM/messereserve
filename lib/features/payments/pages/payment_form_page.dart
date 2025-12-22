import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/primary_button_loading.dart';

class PaymentFormPage extends StatefulWidget {
  const PaymentFormPage({super.key});

  @override
  State<PaymentFormPage> createState() => _PaymentFormPageState();
}

class _PaymentFormPageState extends State<PaymentFormPage> with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  int _selectedOperator = 0; // 0: Airtel, 1: Moov
  bool _saveForLater = false;
  bool _isLoading = false;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
              const Text(
                "Réglez votre messe avec foi et sécurité",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                            _buildOperatorTab("airtel", isActive: _selectedOperator == 0, onTap: () {
                              setState(() => _selectedOperator = 0);
                            }),
                            _buildOperatorTab("moov", isActive: _selectedOperator == 1, onTap: () {
                              setState(() => _selectedOperator = 1);
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildLabel("Numéro Mobile Money"),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "+241 07xx xxx",
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildLabel("Nom du demandeur"),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          "Emma NDONG",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: _saveForLater,
                            onChanged: (v) => setState(() => _saveForLater = v ?? false),
                            activeColor: AppColors.navActive,
                          ),
                          const Expanded(
                            child: Text(
                              "Mémoriser ce moyen pour mes prochaines messes",
                              style: TextStyle(color: Colors.black87),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text(
                        "Annuler",
                        style: TextStyle(color: Colors.black54, fontSize: 16),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildOperatorTab(String operatorAsset,
      {required bool isActive, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isActive
                ? const Border(bottom: BorderSide(color: Color(0xff5722), width: 2))
                : null,
          ),
          child: Center(
            child: Image.asset(
              'assets/icons/$operatorAsset.jpg',
              height: 30,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  void _handlePayment() async {
    if (_phoneController.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Numéro invalide")),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    late final AnimationController controller;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        controller = AnimationController(vsync: this);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          actionsPadding: const EdgeInsets.only(bottom: 12, right: 12),
          title: Column(
            children: [
              Lottie.asset(
                'assets/lottie/success.json',
                height: 100,
                controller: controller,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: const Text(
            "Merci pour votre contribution.\nVous recevrez un SMS de confirmation dans un instant.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                controller.dispose();
                context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navActive,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.home),
              label: const Text("Retour à l'accueil"),
            ),
          ],
        );
      },
    );
  }
}
