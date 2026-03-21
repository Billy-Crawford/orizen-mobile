// lib/features/chat/presentation/chat_list_page.dart

import 'package:flutter/material.dart';
import 'package:orizen_mobile/features/advisor/presentation/advisor_requests_page.dart';
import '../../advisor/presentation/students_list_page.dart';
import '../../auth/presentation/my_advisor_page.dart';
import '../../../core/services/token_service.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  String? role;

  @override
  void initState() {
    super.initState();
    loadRole();
  }

  Future<void> loadRole() async {
    final r = await TokenService.getRole();
    setState(() {
      role = r;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (role == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (role == "advisor") {
      return const AdvisorRequestsPage();
    }

    return const MyAdvisorPage();
  }
}

