// lib/features/advisor/presentation/advisor_dashboard.dart

import 'package:flutter/material.dart';
import '../../../core/services/token_service.dart';

class AdvisorDashboard extends StatelessWidget {
  const AdvisorDashboard({super.key});

  Future<void> _logout(BuildContext context) async {
    await TokenService.clearTokens();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      "/login",
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advisor Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: const Center(
        child: Text(
          "Bienvenue conseiller 👨‍🏫",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}