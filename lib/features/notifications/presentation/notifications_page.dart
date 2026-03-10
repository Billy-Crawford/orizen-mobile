// lib/features/notifications/presentation/notifications_page.dart

import 'package:flutter/material.dart';
import '../data/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

  List notifications = [];
  bool loading = true;
  int unreadCount = 0;

  @override
  void initState() {
    super.initState();
    loadNotifications();
  }

  void loadNotifications() async {

    final data = await NotificationService.getNotifications();

    int count = 0;

    for (var n in data) {
      if (n["is_read"] == false) {
        count++;
      }
    }

    setState(() {
      notifications = data;
      unreadCount = count;
      loading = false;
    });
  }

  void openNotification(Map notif) async {

    if (notif["is_read"] == false) {

      await NotificationService.markAsRead(notif["id"]);

      setState(() {
        notif["is_read"] = true;
        unreadCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(

      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [

          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: Center(
              child: unreadCount > 0
                  ? Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              )
                  : const SizedBox(),
            ),
          )
        ],
      ),

      body: ListView.builder(

        itemCount: notifications.length,

        itemBuilder: (context, index) {

          final n = notifications[index];
          final isRead = n["is_read"];

          return ListTile(

            onTap: () => openNotification(n),

            leading: Icon(
              isRead ? Icons.notifications_none : Icons.notifications,
              color: isRead ? Colors.grey : Colors.blue,
            ),

            title: Text(
              n["title"] ?? "",
              style: TextStyle(
                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              ),
            ),

            subtitle: Text(n["message"] ?? ""),

            trailing: isRead
                ? null
                : const Icon(Icons.circle, color: Colors.blue, size: 10),
          );
        },
      ),
    );
  }
}

