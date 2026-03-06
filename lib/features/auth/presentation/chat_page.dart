// lib/features/student/presentation/chat_page.dart

import 'package:flutter/material.dart';
import '../../student/data/chat_service.dart';

class ChatPage extends StatefulWidget {
  final int relationId;
  final String advisorName;

  const ChatPage({super.key, required this.relationId, required this.advisorName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  List<dynamic> _messages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await _chatService.getMessages(widget.relationId);
      setState(() {
        _messages = response.data;
        _loading = false;
      });
    } catch (e) {
      print("Erreur fetch messages: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    try {
      final response = await _chatService.sendMessage(
        widget.relationId,
        _messageController.text,
      );

      _messageController.clear();
      setState(() {
        _messages.insert(0, response.data); // ajouter en tête
      });
    } catch (e) {
      print("Erreur send message: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Erreur envoi message")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat avec ${widget.advisorName}")),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['sender']['id'] == msg['sender']['id']; // TODO: remplacer par user id courant
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      msg['content'],
                      style: TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Écrire un message...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

