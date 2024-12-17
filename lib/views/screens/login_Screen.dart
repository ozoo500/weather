import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/constants/app_localization.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string.dart';
import '../../constants/app_style.dart';
import '../../controller/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isGoogleSignInLoading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(loadingProvider);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          context.translate(AppString.signIn),
          style: AppStyle.poppins600style18.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 100),
                Semantics(
                  label: 'Email input field',
                  hint: context.translate(AppString.email),
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
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                  ),
                ),
                const SizedBox(height: 20),
                Semantics(
                  label: 'Password input field',
                  hint: context.translate(AppString.password),
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
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                loading
                    ? const CircularProgressIndicator()
                    : CustomElevatedButton(
                        text: context.translate(AppString.signIn),
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
                                      .signInWithEmailAndPassword(
                                          email, password);
                                  ref.read(loadingProvider.notifier).state =
                                      false;
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
                                  if (result != null &&
                                      result.startsWith('invalid-credential')) {
                                    return;
                                  }
                                  if (context.mounted) {
                                    ref.refresh(userDataProvider);

                                    Navigator.pushReplacementNamed(
                                      context,
                                      Routes.homeRoute,
                                    );
                                  }
                                }
                              },
                        backgroundColor:
                            theme.bottomNavigationBarTheme.selectedItemColor!,
                      ),
                const SizedBox(height: 10),
                _isGoogleSignInLoading
                    ? const CircularProgressIndicator()
                    : CustomElevatedButton(
                        text: context.translate(AppString.signInWithGoogle),
                        onPressed: () async {
                          setState(() {
                            _isGoogleSignInLoading = true;
                          });

                          final googleSignInResult = await ref
                              .read(authServiceProvider)
                              .signInWithGoogle();

                          setState(() {
                            _isGoogleSignInLoading = false;
                          });

                          if (context.mounted) {
                            _showSnackBar(context, 'Google sign-in successful',
                                Colors.green);
                            Navigator.pushReplacementNamed(
                                context, Routes.homeRoute);
                          } else {
                            if (context.mounted) {
                              _showSnackBar(
                                  context, 'An error occurred', Colors.red);
                            }
                          }
                        },
                        backgroundColor:
                            theme.bottomNavigationBarTheme.selectedItemColor!,
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      Routes.signUpRoute,
                    );
                  },
                  child: Text(
                    context.translate(AppString.noAccount),
                    style: AppStyle.poppins500style14,
                  ),
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
