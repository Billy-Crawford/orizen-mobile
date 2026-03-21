// lib/features/advisor/presentation/advisor_home_page.dart

import 'package:flutter/material.dart';

import '../../auth/presentation/advisor_dashboard.dart';
import '../presentation/students_list_page.dart';
import '../presentation/advisor_profile.dart';
import 'advisor_requests_page.dart'; // 👈 NOUVEAU

class AdvisorHomePage extends StatefulWidget {
  const AdvisorHomePage({super.key});

  @override
  State<AdvisorHomePage> createState() => _AdvisorHomePageState();
}

class _AdvisorHomePageState extends State<AdvisorHomePage> {

  int _currentIndex = 0;

  final List<Widget> _pages = const [

    AdvisorDashboard(),

    StudentsListPage(),

    AdvisorRequestsPage(), // 👈 NOUVEAU

    // AdvisorProfile(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: "Étudiants",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Demandes",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),

        ],
      ),
    );
  }
}
