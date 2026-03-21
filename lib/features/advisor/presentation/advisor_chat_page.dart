// lib/features/advisor/presentation/advisor_chat_page.dart

import 'package:flutter/material.dart';
import '../data/advisor_service.dart';

class AdvisorChatPage extends StatefulWidget {
  const AdvisorChatPage({super.key});

  @override
  State<AdvisorChatPage> createState() => _AdvisorChatPageState();
}

class _AdvisorChatPageState extends State<AdvisorChatPage> {
  final AdvisorService _service = AdvisorService();
  final TextEditingController _controller = TextEditingController();

  List messages = [];
  bool isLoading = true;

  late Map student;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    student = ModalRoute.of(context)!.settings.arguments as Map;
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final response = await _service.getMessages(student["id"]);

      setState(() {
        messages = response.data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  Future<void> sendMessage() async {
    if (_controller.text.isEmpty) return;

    await _service.sendMessage(student["id"], _controller.text);

    _controller.clear();
    fetchMessages();
  }

  bool isMe(message) {
    return message["sender_username"] == "joecobra"; // ⚠️ à améliorer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student["username"]),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final me = isMe(msg);

                return Align(
                  alignment:
                  me ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: me ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["message"],
                      style: TextStyle(
                        color: me ? Colors.white : Colors.black,
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
                  decoration:
                  const InputDecoration(hintText: "Message..."),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: sendMessage,
              )
            ],
          )
        ],
      ),
    );
  }
}


