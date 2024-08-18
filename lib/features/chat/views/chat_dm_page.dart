import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gchat/constants.dart';
import 'package:gchat/features/chat/views/widgets/chat_tile.dart';

class ChatDMPage extends StatefulWidget {
  const ChatDMPage({super.key});

  @override
  State<ChatDMPage> createState() => _ChatDMPageState();
}

class _ChatDMPageState extends State<ChatDMPage> {
  var _messageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const ChatTile(name: "John Doe"),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 3,
                    controller: _messageController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: const Color(0xfff6f6f6),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xfff6f6f6),
                  ),
                  child: const Icon(
                    Icons.send,
                    size: 30,
                    color: AppColor.iconBackground,
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
