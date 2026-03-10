// lib/features/student/presentation/student_home_page.dart

import 'package:flutter/material.dart';
import 'package:orizen_mobile/features/chat/presentation/chat_list_page.dart';

import '../../auth/presentation/student_dashboard.dart';
import '../../notifications/presentation/notifications_page.dart';

import 'advisors_list_page.dart';
import 'universities_page.dart';
import 'my_candidatures_page.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {

  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      const StudentDashboard(),
      const UniversitiesPage(),
      const MyCandidaturesPage(),
      const AdvisorsListPage(),
      const ChatListPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Orizen"),

        actions: [

          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsPage(),
                ),
              );

            },
          )

        ],
      ),

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
            label: "Universités",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: "Candidatures",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: "Conseillers",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Messages",
          ),

        ],
      ),
    );
  }
}