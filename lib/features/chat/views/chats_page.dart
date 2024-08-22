import 'package:flutter/material.dart';
import 'package:gchat/features/chat/views/widgets/chats_view.dart';
import 'package:gchat/features/chat/views/widgets/profile_view.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (popped) {},
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xfff6f6f6),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Chats",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child:
              _currentTabIndex == 0 ? const ChatsView() : const ProfileView(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() => _currentTabIndex = index);
          },
          currentIndex: _currentTabIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: "Chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_pin),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
