// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gchat/features/chat/model/chat.dart';
import 'package:uuid/v4.dart';

import 'package:gchat/utils.dart';

class ChatRepository {
  ChatRepository._();

  static final ChatRepository instance = ChatRepository._();
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _logger = GChatUtils.getLogger("ChatRepository");
  final uuid = const UuidV4();

  Future<Chat?> initializeChat(String recepientId) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        final currentUserId = user.uid;

        // Go to the chat's collection and check if the chat document already exists
        final querySnapshot =
            await _firebaseFirestore.collection("chats").get();
        final documents = querySnapshot.docs;

        // if it does, return the list of messages associated with the chat id

        final List<Chat> chats = documents.map<Chat>((element) {
          final chat = Chat.fromMap(element.data());
          return chat;
        }).toList();

        final oldChats = chats
            .where(
              (chat) =>
                  chat.members!.contains(recepientId) &&
                  chat.members!.contains(currentUserId),
            )
            .toList();

        if (oldChats.isEmpty) {
          // geenrate a new chat id
          final chatId = uuid.generate();
          // Create a new chat document
          final newChat = Chat(
            chatId: chatId,
            members: [currentUserId, recepientId],
            receipientId: recepientId,
            createdAt: DateTime.now().toString(),
            messages: [],
          );

          await _firebaseFirestore.collection("chats").add(newChat.toMap());
          return newChat;
        } else {
          return oldChats.first;
        }
      } else {
        _logger.e("User is null");
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  /// Sends a new message to the specified recipient.
  ///
  /// [message] The text of the message to be sent.
  /// [receipientId] The ID of the recipient of the message.
  Future<void> sendMessage({
    required String message,
    required String receipientId,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final currentUserId = user.uid;

      // Retrieve the chat document from Firestore
      final querySnapshot = await _firebaseFirestore.collection("chats").get();
      final documents = querySnapshot.docs;

      // Check if the chat document already exists
      if (documents.isNotEmpty) {
        // Map the documents to a list of Chat objects
        final List<Chat> chats = documents.map<Chat>((element) {
          final chat = Chat.fromMap(element.data());
          return chat;
        }).toList();

        // Find the existing chat with the recipient
        final oldChat = chats.firstWhere(
          (chat) =>
              chat.members!.contains(receipientId) &&
              chat.members!.contains(currentUserId),
        );

        // Create a new message
        final newMessageTimeStamp = DateTime.now().toString();
        final newMessage = Message(
          messageId: uuid.generate(),
          senderId: currentUserId,
          receiverId: receipientId,
          message: message,
          createdAt: newMessageTimeStamp,
        );

        // Update the chat document
        oldChat.messages!.add(newMessage);
        oldChat.lastMessage = message;
        oldChat.lastMessageTime = newMessageTimeStamp;

        // Update the chat document in Firestore
        final querySnapshot = await _firebaseFirestore
            .collection("chats")
            .where("chatId", isEqualTo: oldChat.chatId)
            .get();
        querySnapshot.docs.first.reference.update(oldChat.toMap());
      }
    }
  }

  /// Fetches the current user's chat.
  ///
  /// Returns a stream of chats that the current user is a member of.
  Stream<Chat?> fetchChat(String recipientId) {
    try {
      // Get a stream of snapshots from the "chats" collection
      final chatStream = _firebaseFirestore.collection("chats").snapshots();

      // Transform the stream to filter and map chat documents
      return chatStream.transform(
        StreamTransformer.fromHandlers(
          handleData: (QuerySnapshot<Map<String, dynamic>> data,
              EventSink<Chat?> sink) {
            // Filter chats that the current user is a member of
            final userChats = data.docs
                .map((data) => Chat.fromMap(data.data()))
                .toList()
                .where(
                  (chat) =>
                      chat.members!.contains(_firebaseAuth.currentUser!.uid) &&
                      chat.members!.contains(recipientId),
                )
                .toList();

            // Add the first matching chat to the sink
            if (userChats.isEmpty) {
              sink.add(null);
            } else {
              sink.add(userChats.first);
            }
          },
        ),
      );
    } catch (e) {
      // Rethrow any exceptions for further error handling and debugging
      rethrow;
    }
  }
}
