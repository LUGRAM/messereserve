// lib/features/auth/pages/register_page.dart
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

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  final AuthController _auth = Get.put(AuthController());

  @override
  void dispose() {
    _nameCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    print("Tentative d'inscription: Nom=${_nameCtrl.text}, Phone=${_phoneCtrl.text}, Pass=${_passCtrl.text}");

    final success = await _auth.register(
      _nameCtrl.text,
      _phoneCtrl.text,
      _passCtrl.text,
    );

    print(success);

    if (success) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.snackbar(
        "Inscription échouée",
        "Impossible de créer le compte. Vérifiez vos informations.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),

                  AppTextField(
                    hint: 'Nom',
                    icon: Icons.person_outline,
                    controller: _nameCtrl,
                  ),

                  const SizedBox(height: 16),

                  IntlPhoneField(
                    initialCountryCode: 'GA',
                    invalidNumberMessage: "Numéro de téléphone invalide",
                    decoration: InputDecoration(
                      hintText: "Numéro de téléphone",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
                    controller: _passCtrl,
                    maxLength: 8,
                  ),

                  const SizedBox(height: 16),

                  AppTextField(
                    hint: 'Confirmation',
                    icon: Icons.check_circle_outline,
                    obscure: true,
                    controller: _confirmCtrl,
                    maxLength: 8,
                    validator: (v) =>
                    v != _passCtrl.text ? 'Non conforme' : null,
                  ),

                  const SizedBox(height: 24),

                  Obx(() => PrimaryButton(
                    label: _auth.isLoading.value
                        ? "Création..."
                        : "S'inscrire",
                    isLoading: _auth.isLoading.value,
                    onPressed:
                    _auth.isLoading.value ? null : _submit,
                  )),

                  const SizedBox(height: 24),

                  RichText(
                    text: TextSpan(
                      text: "Déjà inscrit ? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        TextSpan(
                          text: "Se connecter",
                          style: TextStyle(
                            color: AppColors.textYellow,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Get.offAllNamed(Routes.login),
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
