// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gchat/extensions.dart';
import 'package:gchat/features/chat/model/chat.dart';
import 'package:gchat/features/chat/repositories/chat_repository.dart';
import 'package:gchat/features/chat/viewmodels/chat_viewmodel.dart';
import 'package:gchat/features/onboarding/viewmodel/signup_viewmodel.dart';
import 'package:gchat/utils.dart';
import 'package:provider/provider.dart';

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

                            return ListView.separated(
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                final message = _messages[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: AppColor.iconBackground,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  margin: message.senderId ==
                                          context
                                              .read<AuthViewModel>()
                                              .currentAuthUser!
                                              .uid
                                      ? const EdgeInsets.only(left: 129)
                                      : const EdgeInsets.only(right: 129),
                                  child: Text(
                                    message.message ?? "",
                                    style: context.textTheme.bodyLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
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
      // _messageController.value.text = "";
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
