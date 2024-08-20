// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gchat/extensions.dart';
import 'package:gchat/features/chat/model/chat.dart';
import 'package:gchat/features/chat/viewmodels/chat_viewmodel.dart';
import 'package:gchat/features/onboarding/viewmodel/signup_viewmodel.dart';
import 'package:gchat/utils.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:gchat/constants.dart';
import 'package:gchat/features/chat/views/widgets/chat_tile.dart';
import 'package:gchat/features/user/models/user.dart';

class ChatDMPage extends StatefulWidget {
  final GChatUser receipient;
  const ChatDMPage({super.key, required this.receipient});

  @override
  State<ChatDMPage> createState() => _ChatDMPageState();
}

class _ChatDMPageState extends State<ChatDMPage> with RestorationMixin {
  final _messageController = RestorableTextEditingController();
  List<Message> _messages = [];
  late Stream<Chat> _chatStream;

  void _registerForRestoration() {
    registerForRestoration(_messageController, "messageController");
  }

  void _initializeChat() async {
    final chat = await context
        .read<ChatsViewModel>()
        .initializeChat(uid: widget.receipient.uid);
    if (chat != null) {
      setState(() => _messages = chat.messages ?? []);
    }
  }

  @override
  String get restorationId => 'chat_dm_page';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    _registerForRestoration();
  }

  @override
  void initState() {
    super.initState();
    _registerForRestoration();
    _initializeChat();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _chatStream = context.read<ChatsViewModel>().fetchChat();
    final currentUserId = context.read<AuthViewModel>().currentAuthUser?.uid;
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: ChatTile(user: widget.receipient),
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
                    child: StreamBuilder<Chat>(
                      stream: _chatStream,
                      builder: (context, AsyncSnapshot<Chat> snapshot) {
                        if (snapshot.hasData) {
                          final chat = snapshot.data;
                          if (chat == null) {
                            return const Center(
                              child: Text("No messages yet"),
                            );
                          } else {
                            _messages = chat.messages ?? [];

                            if (_messages.isEmpty) {
                              ;
                              return const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      size: 40,
                                    ),
                                    Text("Start new conversation with user!")
                                  ],
                                ),
                              );
                            }

                            return ListView.separated(
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                final message = _messages[index];
                                return message.senderId == currentUserId
                                    ? Row(
                                        children: [
                                          const Expanded(child: SizedBox()),
                                          ChatBubble(
                                            message: message,
                                            userId: currentUserId ?? "",
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          ChatBubble(
                                            message: message,
                                            userId: currentUserId ?? "",
                                          ),
                                          const Expanded(child: SizedBox()),
                                        ],
                                      );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 16),
                              shrinkWrap: true,
                            );
                          }
                        } else {
                          return ListView.separated(
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              return Container(height: 24, color: Colors.red);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16),
                            shrinkWrap: true,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    controller: _messageController.value,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(36),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: const Color(0xfff6f6f6),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: sendMessage,
                  child: Container(
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
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> sendMessage() async {
    try {
      final message = _messageController.value.text;
      if (message.isEmpty) return;
      _messageController.value.text = "";
      await context.read<ChatsViewModel>().sendMessage(
            message: message,
            receipient: widget.receipient.uid,
          );
    } catch (e) {
      GChatUtils.showSnackbar(
        context,
        e.toString(),
        backgroundColor: Colors.red,
      );
    }
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.userId,
  });

  final Message message;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(
            maxWidth: 250,
          ),
          decoration: BoxDecoration(
            color: message.receiverId == userId
                ? Colors.white
                : const Color(0xffdfa532),
            borderRadius: BorderRadius.circular(32),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: message.receiverId != userId
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                message.message ?? "",
                style: context.textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                ),
              ),
              Text(
                DateFormat("hh:mm").format(
                  DateTime.parse(
                    message.createdAt.toString(),
                  ),
                ),
                style: TextStyle(
                  fontSize: 10,
                color: message.receiverId != userId
                ? Colors.white
                : const Color(0xffdfa532),
                 ),
              ),
            ],
          ),
        ),
        // Positioned(
        //   child:
        // )
      ],
    );
  }
}
