// lib/features/advisor/presentation/advisor_home_page.dart

import 'package:flutter/material.dart';
import 'package:orizen_mobile/features/advisor/presentation/students_list_page.dart';
import 'package:orizen_mobile/features/chat/presentation/chat_list_page.dart';

import '../../auth/presentation/advisor_dashboard.dart';
import 'advisor_profile.dart';
import 'advisor_chat_page.dart';

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
    AdvisorProfilePage(),
    AdvisorChatPage(),
    ChatListPage(),
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
            label: "Etudiants",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Messagerie",
          ),
        ],
      ),
    );
  }
}