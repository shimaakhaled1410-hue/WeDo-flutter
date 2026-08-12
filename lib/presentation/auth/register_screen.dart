import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedo_flutter/core/router/app_routes.dart';
import 'package:wedo_flutter/core/widgets/custom_button.dart';
import 'package:wedo_flutter/core/widgets/custom_snackbar.dart';
import 'package:wedo_flutter/core/widgets/custom_text_field.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_cubit.dart';
import 'package:wedo_flutter/presentation/manager/auth/auth_state.dart';
import '../../core/theme/app_colors.dart';
import 'widgets/auth_card.dart';
import 'widgets/auth_footer_link.dart';
import 'widgets/auth_gradient_title.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AuthGradientTitle(
                    heading: 'Create an Account',
                    subheading: 'Join WeDo to collaborate on tasks',
                  ),
                  const SizedBox(height: 32),
                  AuthCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          label: 'Full Name',
                          hint: 'John Doe',
                          icon: Icons.person_outline,
                          controller: _nameController,
                          validator: (val) => (val == null || val.trim().isEmpty)
                              ? 'Please enter your name'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Email',
                          hint: 'you@example.com',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (val) => (val == null || val.trim().isEmpty)
                              ? 'Please enter your email'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          label: 'Password',
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          isPassword: true,
                          controller: _passwordController,
                          validator: (val) => (val == null || val.length < 6)
                              ? 'Password must be at least 6 characters'
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
                              CustomSnackBar.show(
                                context: context,
                                message: 'Account Created Successfully!',
                                isError: false,
                              );
                              context.go(AppRoutes.home);
                            }
                          },
                          builder: (context, state) {
                            return CustomButton(
                              text: 'Sign Up',
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
                    leadingText: 'Already have an account? ',
                    actionText: 'Login',
                    onTap: () => context.push(AppRoutes.login),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}