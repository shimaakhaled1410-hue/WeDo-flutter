import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import 'package:wedo_flutter/core/widgets/custom_button.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/core/widgets/custom_text_field.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_cubit.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_state.dart';
import 'package:wedo_flutter/presentation/manager/locale/locale_cubit.dart';
import '../../core/extensions/localization_x.dart';
import '../../core/theme/app_color_scheme.dart';
import 'widgets/auth_card.dart';
import 'widgets/auth_footer_link.dart';
import 'widgets/auth_gradient_title.dart';
import 'widgets/auth_language_toggle.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().register(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    }
  }

  void _navigateAfterRegister(BuildContext context) {
    final redirectProjectId = GoRouterState.of(
      context,
    ).uri.queryParameters['redirectProjectId'];

    if (redirectProjectId != null && redirectProjectId.isNotEmpty) {
      context.go('/join?projectId=$redirectProjectId');
    } else {
      context.go(AppRoutes.home);
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
                      Image.asset(
                        'assets/images/wedo_logo.png',
                        width: 64,
                        height: 64,
                      ),
                      const SizedBox(height: 12),
                      AuthGradientTitle(
                        heading: l10n.createAccount,
                        subheading: l10n.registerSubtitle,
                      ),
                      const SizedBox(height: 32),
                      AuthCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextField(
                              label: l10n.fullName,
                              hint: 'John Doe',
                              icon: Icons.person_outline,
                              controller: _nameController,
                              validator: (val) =>
                                  (val == null || val.trim().isEmpty)
                                  ? l10n
                                        .nameRequired // placeholder below
                                  : null,
                            ),
                            const SizedBox(height: 16),
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
                              validator: (val) =>
                                  (val == null || val.length < 6)
                                  ? l10n.passwordMinLength
                                  : null,
                            ),
                            const SizedBox(height: 24),
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
                                    message: l10n.accountCreatedSuccess,
                                    isError: false,
                                  );
                                  _navigateAfterRegister(context);
                                }
                              },
                              builder: (context, state) {
                                return CustomButton(
                                  text: l10n.signUp,
                                  isLoading: state is AuthLoading,
                                  onPressed: _submit,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AuthFooterLink(
                        leadingText: l10n.alreadyHaveAccount,
                        actionText: l10n.login,
                        onTap: () {
                          final redirectProjectId = GoRouterState.of(
                            context,
                          ).uri.queryParameters['redirectProjectId'];
                          if (redirectProjectId != null &&
                              redirectProjectId.isNotEmpty) {
                            context.push(
                              '${AppRoutes.login}?redirectProjectId=$redirectProjectId',
                            );
                          } else {
                            context.push(AppRoutes.login);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(top: 8, right: 8, child: AuthLanguageToggle()),
          ],
        ),
      ),
    );
  }
}
