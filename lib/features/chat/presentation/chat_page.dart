// lib/features/chat/presentation/chat_page.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/token_service.dart';
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

  final ChatService _service = ChatService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List messages = [];
  bool loading = true;

  int? myUserId;

  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    initChat();
  }

  Future<void> initChat() async {

    myUserId = await TokenService.getUserId();

    await fetchMessages();

    /// auto refresh toutes les 2s
    refreshTimer = Timer.periodic(
      const Duration(seconds: 2),
          (_) => fetchMessages(),
    );
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchMessages() async {

    try {

      final response = await _service.getMessages(widget.userId);

      setState(() {
        messages = response.data;
        loading = false;
      });

      /// scroll automatique vers le bas
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }
      });

    } catch (e) {
      print("Erreur messages: $e");
      setState(() => loading = false);
    }
  }

  Future<void> sendMessage() async {

    final text = _controller.text.trim();

    if (text.isEmpty) return;

    try {

      await _service.sendMessage(widget.userId, text);

      _controller.clear();

      fetchMessages();

    } catch (e) {
      print("Erreur envoi message: $e");
    }
  }

  Widget buildMessage(Map msg) {

    final bool isMe = msg["sender"] == myUserId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(

        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),

        constraints: const BoxConstraints(maxWidth: 260),

        decoration: BoxDecoration(

          color: isMe ? Colors.blue : Colors.grey.shade300,

          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe
                ? const Radius.circular(16)
                : const Radius.circular(0),
            bottomRight: isMe
                ? const Radius.circular(0)
                : const Radius.circular(16),
          ),
        ),

        child: Text(
          msg["message"],
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
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
        title: Text(widget.username),
      ),

      body: Column(
        children: [

          /// LISTE DES MESSAGES

          Expanded(
            child: ListView.builder(

              controller: _scrollController,

              itemCount: messages.length,

              itemBuilder: (context, index) {

                final msg = messages[index];

                return buildMessage(msg);
              },
            ),
          ),

          /// ZONE SAISIE MESSAGE

          Container(
            padding: const EdgeInsets.all(10),

            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                CircleAvatar(
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: sendMessage,
                  ),
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}



