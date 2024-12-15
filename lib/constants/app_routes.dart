import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weather_app/views/screens/sign_up.dart';

import '../views/screens/home_screen.dart';
import '../views/screens/login_Screen.dart';
import '../views/screens/splash_screen.dart';


class Routes {
  static const String splashRoute = '/';
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';
  static const String signUpRoute = '/signUp';
  static const String searchRoute = 'search';

  static Route? getRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              SemanticsService.announce(
                "Splash Screen Loaded Please wait",
                TextDirection.ltr,
              );
            });
            return const SplashScreen();
          },
        );
      case loginRoute:
        return MaterialPageRoute(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              SemanticsService.announce(
                "Login Screen. Enter your credentials to log in.",
                TextDirection.ltr,
              );
            });
            return const LoginScreen();
          },
        );
      case homeRoute:
        return MaterialPageRoute(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              SemanticsService.announce(
                "Home Screen loaded. Navigate through the app using the bottom navigation bar.",
                TextDirection.ltr,
              );
            });
            return const HomeScreen();
          },
        );

      case signUpRoute:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );


      default:
        return MaterialPageRoute(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              SemanticsService.announce(
                "Home Screen loaded. Default navigation.",
                TextDirection.ltr,
              );
            });
            return const HomeScreen();
          },
        );
    }
  }
}
