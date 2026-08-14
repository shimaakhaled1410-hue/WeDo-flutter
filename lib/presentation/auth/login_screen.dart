import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_cubit.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_state.dart';
import 'package:wedo_flutter/presentation/manager/locale/locale_cubit.dart';
import '../../core/extensions/localization_x.dart';
import '../../core/theme/app_color_scheme.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/custom_button.dart';
import 'widgets/auth_card.dart';
import 'widgets/auth_footer_link.dart';
import 'widgets/auth_gradient_title.dart';
import 'widgets/auth_language_toggle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AuthGradientTitle(
                        heading: l10n.welcomeBack,
                        subheading: l10n.loginSubtitle,
                      ),
                      const SizedBox(height: 32),
                      AuthCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              label: l10n.email,
                              hint: l10n.emailHint,
                              icon: Icons.mail_outline,
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              validator: (val) =>
                                  (val == null || val.trim().isEmpty)
                                  ? l10n.emailRequired
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              label: l10n.password,
                              hint: l10n.passwordHint,
                              icon: Icons.lock_outline,
                              isPassword: true,
                              controller: _passwordController,
                              validator: (val) => (val == null || val.isEmpty)
                                  ? l10n.passwordRequired
                                  : null,
                            ),
                            const SizedBox(height: 28),
                            BlocConsumer<AuthCubit, AuthState>(
                              listener: (context, state) {
                                if (state is AuthError) {
                                  CustomSnackBar.show(
                                    context: context,
                                    message: state.message,
                                    isError: true,
                                  );
                                } else if (state is AuthSuccess) {
                                  context
                                      .read<LocaleCubit>()
                                      .syncCurrentLocale();

                                  CustomSnackBar.show(
                                    context: context,
                                    message: l10n.welcomeBack,
                                    isError: false,
                                  );
                                  context.go(AppRoutes.home);
                                }
                              },
                              builder: (context, state) {
                                return CustomButton(
                                  text: l10n.login,
                                  isLoading: state is AuthLoading,
                                  onPressed: _submit,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: AuthFooterLink(
                                leadingText: l10n.dontHaveAccount,
                                actionText: l10n.signUp,
                                onTap: () => context.push(AppRoutes.register),
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
            Positioned(top: 8, right: 8, child: const AuthLanguageToggle()),
          ],
        ),
      ),
    );
  }
}
