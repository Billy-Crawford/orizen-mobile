// lib/core/config/role_router.dart

import 'package:flutter/material.dart';
import '../../features/student/presentation/student_home_page.dart';
import '../../features/advisor/presentation/advisor_home_page.dart';
import '../services/token_service.dart';

class RoleRouter extends StatefulWidget {
  const RoleRouter({super.key});

  @override
  State<RoleRouter> createState() => _RoleRouterState();
}

class _RoleRouterState extends State<RoleRouter> {

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {

    final role = await TokenService.getRole();

    if (!mounted) return;

    if (role == "advisor") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AdvisorHomePage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const StudentHomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

