import 'package:flutter/material.dart';
import 'package:gchat/features/chat/views/widgets/chat_tile.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: const [
        ChatTile(name: "John Doe"),
        SizedBox(height: 16),
        ChatTile(name: "Mary Jean")
      ],
    );
  }
}
