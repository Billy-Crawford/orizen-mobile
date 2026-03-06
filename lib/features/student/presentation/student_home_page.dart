// lib/features/student/presentation/student_home_page.dart

import 'package:flutter/material.dart';
import 'package:orizen_mobile/features/chat/presentation/chat_list_page.dart';
import '../../auth/presentation/chat_page.dart';
import '../../auth/presentation/my_advisor_page.dart';
import '../../auth/presentation/student_dashboard.dart';
import 'advisors_list_page.dart';


class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  int _currentIndex = 0;

  // Ces pages sont créées mais ChatPage a besoin d'un relationId réel
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const StudentDashboard(),
      const AdvisorsListPage(),
      const MyAdvisorPage(),
      const ChatListPage(),
      const ChatPage(
        relationId: 1,
        advisorName: "Conseiller",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Conseillers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Mon conseiller",
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


