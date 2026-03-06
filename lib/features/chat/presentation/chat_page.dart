// lib/features/chat/presentation/chat_page.dart

import 'package:flutter/material.dart';
import '../data/chat_service.dart';

class ChatPage extends StatefulWidget {

  final int userId;
  final String username;

  const ChatPage({
    super.key,
    required this.userId,
    required this.username,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  final List<String> messages = [];

  Future<void> sendMessage() async {

    final text = _controller.text.trim();

    if (text.isEmpty) return;

    await _chatService.sendMessage(
      userId: widget.userId,
      message: text,
    );

    setState(() {
      messages.add(text);
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.username),
      ),

      body: Column(
        children: [

          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {

                return ListTile(
                  title: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.blue,
                      child: Text(
                        messages[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Row(
            children: [

              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: "Message...",
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

