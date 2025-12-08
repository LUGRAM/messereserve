// lib/features/auth/pages/register_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:messeconnect/app/widgets/app_text_field.dart';
import 'package:messeconnect/app/widgets/gradient_background.dart';
import 'package:messeconnect/app/widgets/primary_button.dart';

import '../../../app/theme/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: utiliser AuthController (register)
    context.go('/home');
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
                // top bar
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

                SizedBox(height: size.height * 0.06),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        hint: 'Nom utilisateur',
                        icon: Icons.person_outline,
                        controller: _nameCtrl,
                        validator: (value) =>
                        (value == null || value.isEmpty)
                            ? 'Veuillez saisir votre nom'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        hint: 'Adresse email',
                        icon: Icons.email_outlined,
                        controller: _emailCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir votre email';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Email invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        hint: 'Mot de passe',
                        icon: Icons.lock_outline,
                        obscure: true,
                        controller: _passCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez saisir un mot de passe';
                          }
                          if (value.length < 8) {
                            return 'Minimum 8 caractères';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        hint: 'Confirmation mot de passe',
                        icon: Icons.check_circle_outline,
                        obscure: true,
                        controller: _confirmCtrl,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez confirmer';
                          }
                          if (value != _passCtrl.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      PrimaryButton(
                        label: "S'inscrire",
                        onPressed: _submit,
                      ),

                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          text: 'J’ai déjà un compte. ',
                          style: Theme.of(context).textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Se connecter',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => context.go('/login'),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                color: AppColors.textYellow,
                                fontWeight: FontWeight.bold,
                              ),
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
