// lib/features/chat/presentation/chat_page.dart

import 'package:flutter/material.dart';
import '../../../core/services/token_service.dart';
import '../data/chat_service.dart';

class ChatPage extends StatefulWidget {

  final int relationId;
  final String advisorName;

  const ChatPage({
    super.key,
    required this.relationId,
    required this.advisorName,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  List<Map<String, dynamic>> messages = [];
  bool loading = true;

  int? myUserId;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initChat();
  }

  Future<void> initChat() async {
    myUserId = await TokenService.getUserId();
    loadMessages();
  }

  void loadMessages() async {

    setState(() => loading = true);

    try {

      final data = await ChatService.getMessages(widget.relationId);

      final List<Map<String, dynamic>> cleanMessages = [];

      for (final item in data) {

        // 🔒 Vérification stricte du type
        if (item == null) continue;

        if (item is Map) {

          final map = Map<String, dynamic>.from(item);

          // 🔒 Vérification des champs obligatoires
          if (map["message"] != null && map["sender"] != null) {
            cleanMessages.add(map);
          }
        }
      }

      setState(() {
        messages = cleanMessages;
        loading = false;
      });

    } catch (e) {

      debugPrint("❌ LOAD ERROR: $e");

      setState(() {
        messages = [];
        loading = false;
      });
    }
  }

  void sendMessage() async {

    final content = _controller.text.trim();
    if (content.isEmpty) return;

    _controller.clear();

    try {
      await ChatService.sendMessage(widget.relationId, content);
      loadMessages();
    } catch (e) {
      debugPrint("❌ SEND ERROR: $e");
    }
  }

  Widget buildMessage(Map<String, dynamic> m) {

    final isMe = m["sender"] == myUserId;

    final message = (m["message"] ?? "").toString();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.advisorName),
      ),

      body: Column(
        children: [

          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : messages.isEmpty
                ? const Center(child: Text("Aucun message"))
                : ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {

                final m = messages[messages.length - 1 - index];

                return buildMessage(m);
              },
            ),
          ),

          Row(
            children: [

              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Écrire un message...",
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              ),

            ],
          )

        ],
      ),
    );
  }
}
