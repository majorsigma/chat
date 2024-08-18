import 'package:flutter/material.dart';
import 'package:gchat/constants.dart';
import 'package:gchat/features/chat/views/widgets/chat_tile.dart';
import 'package:gchat/features/chat/views/widgets/profile_tile.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Chats",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _currentTabIndex == 0 ? const ChatsView() : const ProfileView(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
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
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(Object context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ProfileTile(name: "Emm Obi", email: "emm.obi@gmail.com"),
          SizedBox(height: 24),
          Text(
            "Logout",
            style: TextStyle(
              color: AppColor.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          )
        ],
      ),
    );
  }
}

class ChatsView extends StatelessWidget {
  const ChatsView({
    super.key,
  });

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
