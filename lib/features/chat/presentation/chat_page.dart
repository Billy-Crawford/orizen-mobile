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

  List messages = [];
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

    final data = await ChatService.getMessages(widget.relationId);

    setState(() {
      messages = data;
      loading = false;
    });
  }

  void sendMessage() async {

    final content = _controller.text.trim();
    if (content.isEmpty) return;

    _controller.clear();

    await ChatService.sendMessage(widget.relationId, content);

    loadMessages();
  }

  Widget buildMessage(Map m) {

    final bool isMe = m["sender"] == myUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMe ? 12 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 12),
          ),
        ),
        child: Text(
          m["message"] ?? "",
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
                : ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {

                final m = messages[messages.length - 1 - index];

                return buildMessage(m);
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[100],
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Écrire un message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}

