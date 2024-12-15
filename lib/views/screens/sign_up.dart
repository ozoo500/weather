import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/constants/app_localization.dart';

import '../../constants/app_routes.dart';
import '../../constants/app_string.dart';
import '../../constants/app_style.dart';
import '../../controller/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'login_Screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loading = ref.watch(loadingProvider);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Semantics(
            label: "Sign up page",
            child: Text(
              context.translate(AppString.signUp),
              style: AppStyle.poppins600style18.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyLarge?.color),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Semantics(
                  label: 'Email input field',
                  child: CustomTextFormField(
                    controller: emailController,
                    hintText: context.translate(AppString.email),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                    inputTextStyle: TextStyle(
                      color: theme.bottomNavigationBarTheme.selectedItemColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 20),
                Semantics(
                  label: 'Password input field',
                  child: CustomTextFormField(
                    controller: passwordController,
                    hintText: context.translate(AppString.password),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                    inputTextStyle: TextStyle(
                      color: theme.bottomNavigationBarTheme.selectedItemColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                Semantics(
                  label: 'Confirm Password input field',
                  child: CustomTextFormField(
                    controller: confirmPasswordController,
                    hintText: context.translate(AppString.confirmPassword),
                    obscureText: true,
                    inputTextStyle: TextStyle(
                      color: theme.bottomNavigationBarTheme.selectedItemColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 20),
                loading
                    ? const CircularProgressIndicator()
                    : CustomElevatedButton(
                        text: context.translate(AppString.signUp),
                        onPressed: loading
                            ? null
                            : () async {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  final email = emailController.text;
                                  final password = passwordController.text;

                                  ref.read(loadingProvider.notifier).state =
                                      true;

                                  final authService =
                                      ref.read(authServiceProvider);
                                  final result = await authService
                                      .createUserWithEmailPassword(
                                          email, password);

                                  ref.read(loadingProvider.notifier).state =
                                      false; // Stop loading

                                  if (result != null) {
                                    if (context.mounted) {
                                      _showSnackBar(
                                          context,
                                          result,
                                          result.startsWith('Error')
                                              ? Colors.red
                                              : Colors.green);
                                    }
                                  }
                                  if (context.mounted) {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.loginRoute,
                                    );
                                  }
                                }
                              },
                        backgroundColor:
                            theme.bottomNavigationBarTheme.selectedItemColor!,
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  child: Text(context.translate(AppString.haveAnAccount),
                      style: AppStyle.poppins500style14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }
}
