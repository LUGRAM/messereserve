// lib/features/auth/pages/login_page.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:go_router/go_router.dart';
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

  final AuthController _authController = Get.put(AuthController());

  final AuthController _auth = Get.put(AuthController());

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    bool ok = await _auth.login(
      _phoneCtrl.text,
      _passwordCtrl.text,
    );

    if (ok) {
      Get.offAllNamed("/home"); // user authentifié
    } else {
      Get.snackbar("Erreur", "Impossible de créer le compte");
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar (menu + icône croix)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.menu, color: Colors.white),
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.church, color: AppColors.gradientBottom),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.08),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      IntlPhoneField(
                        decoration: InputDecoration(
                          hintText: "Numéro de téléphone",
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        initialCountryCode: 'GA', // Gabon
                        onChanged: (phone) {
                          _phoneCtrl.text = phone.completeNumber; // +241XXXXXXXX
                        },
                        onCountryChanged: (country) {
                          print('Pays sélectionné : ${country.name}');
                        },
                        validator: (value) {
                          if (value == null || value.number.isEmpty) {
                            return 'Veuillez saisir votre numéro';
                          }
                          if (value.number.length < 6) {
                            return 'Numéro invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        hint: 'Mot de passe',
                        icon: Icons.lock_outline,
                        obscure: true,
                        controller: _passwordCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir votre mot de passe';
                          }
                          if (value.length < 8) {
                            return 'Au moins 8 caractères';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Mot de passe oublié?',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // PrimaryButton(
                      //   label: 'Se connecter',
                      //   onPressed: _submit,
                      // ),
                      Obx(() {
                        return PrimaryButton(
                          label: _authController.isLoading.value ? "Chargement..." : "Se connecter",
                          isLoading: _authController.isLoading.value, // si ton bouton gère un loader interne
                          onPressed: _authController.isLoading.value ? null : _submit,
                        );
                      }),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          text: 'Vous n’avez pas de compte?  ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'S’inscrire',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textYellow,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: (TapGestureRecognizer()..onTap = () {
                                Get.offAllNamed(Routes.register);
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
