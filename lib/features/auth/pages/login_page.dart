// lib/features/auth/pages/login_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'package:messeconnect/app/router/routes.dart';
import 'package:messeconnect/app/widgets/app_text_field.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';
import 'package:messeconnect/app/widgets/primary_button.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final AuthController _auth = Get.find<AuthController>();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _auth.login(
      _phoneCtrl.text,
      _passwordCtrl.text,
    );

    if (success) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.snackbar(
        "Connexion échouée",
        "Numéro ou mot de passe incorrect",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.04,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),

                  IntlPhoneField(
                    initialCountryCode: 'GA',
                    decoration: InputDecoration(
                      hintText: "Numéro de téléphone",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onChanged: (phone) =>
                    _phoneCtrl.text = phone.completeNumber,
                    validator: (value) =>
                    value == null || value.number.isEmpty
                        ? 'Numéro requis'
                        : null,
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    hint: 'Mot de passe',
                    icon: Icons.lock_outline,
                    obscure: true,
                    controller: _passwordCtrl,
                  ),

                  const SizedBox(height: 24),

                  Obx(() => PrimaryButton(
                    label: _auth.isLoading.value
                        ? "Connexion..."
                        : "Se connecter",
                    isLoading: _auth.isLoading.value,
                    onPressed:
                    _auth.isLoading.value ? null : _submit,
                  )),

                  const SizedBox(height: 24),

                  RichText(
                    text: TextSpan(
                      text: "Pas encore de compte ? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: "S'inscrire",
                          style: TextStyle(
                            color: AppColors.textYellow,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Get.offAllNamed(Routes.register),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
