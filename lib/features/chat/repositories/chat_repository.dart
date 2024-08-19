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
        if (documents.isNotEmpty) {
          final List<Chat> chats = documents.map<Chat>((element) {
            final chat = Chat.fromMap(element.data());
            return chat;
          }).toList();
          final oldChat = chats
              .where(
                (chat) => chat.members!.contains(recepientId),
              )
              .first;

          return oldChat;
        } else {
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

          _logger.d("New chat: ${newChat.toMap()}");

          await _firebaseFirestore.collection("chats").add(newChat.toMap());
          return newChat;
        }
      } else {
        _logger.e("User is null");
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<void> sendMessage({
    required String message,
    required String receipientId,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final currentUserId = user.uid;

      // Go to the chat's collection and check if the chat document already exists
      final querySnapshot = await _firebaseFirestore.collection("chats").get();
      final documents = querySnapshot.docs;

      // if it does, return the list of messages associated with the chat id
      if (documents.isNotEmpty) {
        final List<Chat> chats = documents.map<Chat>((element) {
          final chat = Chat.fromMap(element.data());
          return chat;
        }).toList();
        final oldChat = chats
            .where(
              (chat) => chat.members!.contains(receipientId),
            )
            .first;
        final newMessageTimeStamp = DateTime.now().toString();
        final newMessage = Message(
          messageId: uuid.generate(),
          senderId: currentUserId,
          receiverId: receipientId,
          message: message,
          createdAt: newMessageTimeStamp,
        );

        oldChat.messages!.add(newMessage);
        oldChat.lastMessage = message;
        oldChat.lastMessageTime = newMessageTimeStamp;

        final querySnapshot = await _firebaseFirestore
            .collection("chats")
            .where("chatId", isEqualTo: oldChat.chatId)
            .get();
        querySnapshot.docs.first.reference.update(oldChat.toMap());

        _logger.d("New message ${oldChat.toMap()}");
      }
    }
  }

  // Stream<Chat?> fetchChat() async {
  //   try {
  //     final user = _firebaseAuth.currentUser;
  //     if (user != null) {
  //       final currentUserId = user.uid;

  //       // Go to the chat's collection and check if the chat document already exists
  //       final querySnapshot =
  //           await _firebaseFirestore.collection("chats").get();
  //       final documents = querySnapshot.docs;

  //       // if it does, return the list of messages associated with the chat id
  //       if (documents.isNotEmpty) {
  //         final List<Chat> chats = documents.map<Chat>((element) {
  //           final chat = Chat.fromJson(element.data());
  //           return chat;
  //         }).toList();
  //         final oldChat = chats
  //             .where(
  //               (chat) => chat.members!.contains(receipientId),
  //             )
  //             .first;

  //         return oldChat;
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     throw Exception(e.message);
  //   } on FirebaseException catch (e) {
  //     throw Exception(e.message);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Stream<Chat> fetchChat() {
    try {
      // Query the "users" collection in Firebase Firestore to retrieve all user documents
      // except the current user's document, using the current user's UID as a filter
      final query = _firebaseFirestore
          .collection("chats")
          .where(
            "chatId",
            isNotEqualTo: _firebaseAuth.currentUser?.uid,
          ) // Filter out the current user
          .get()
          .asStream();

      StreamTransformer<QuerySnapshot<Map<String, dynamic>>, Chat>
          streamTransformer = StreamTransformer.fromHandlers(
        handleData: (
          QuerySnapshot<Map<String, dynamic>> data,
          EventSink<Chat> sink,
        ) {
          final chatSnapshot = data.docs.where((test) => test.exists);
          final chat = Chat.fromMap(chatSnapshot.first.data());
          sink.add(chat);
        },
      );

      final chatStream = query.transform(streamTransformer);

      // Return the list of GChatUser objects
      return chatStream;
    } on FirebaseAuthException catch (e) {
      // Catch any Firebase Authentication-specific exceptions and rethrow as a general Exception
      throw Exception(e.message);
    } on FirebaseException catch (e) {
      // Catch any other Firebase-specific exceptions and rethrow as a general Exception
      throw Exception(e.message);
    } catch (e) {
      // Rethrow any other exceptions for further error handling and debugging
      rethrow;
    }
  }
}
