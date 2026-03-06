// lib/core/config/app_router.dart

import 'package:flutter/material.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/splash_page.dart';
import 'role_router.dart';

class AppRouter {

  static Map<String, WidgetBuilder> routes = {

    "/": (context) => const SplashPage(),

    "/login": (context) => const LoginPage(),

    "/register": (context) => const RegisterPage(),

    "/role-router": (context) => const RoleRouter(),
  };
}

