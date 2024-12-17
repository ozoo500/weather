import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_assets.dart';
import '../../constants/app_routes.dart';
import '../../controller/auth_controller.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.primaryColor,
      body: authState.when(
        data: (user) {
          Future.delayed(const Duration(seconds: 2), () {
            if (user != null) {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, Routes.homeRoute);
              }
            } else {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, Routes.loginRoute);
              }
            }
          });

          return Center(
            child: Semantics(
              label: "Splash Image weather",
              child: Image.asset(
                AppAssets.clouds,
                width: 189,
                height: 189,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
