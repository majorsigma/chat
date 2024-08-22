import 'package:flutter/material.dart';
import 'package:gchat/features/chat/model/chat.dart';
import 'package:gchat/features/chat/repositories/chat_repository.dart';

class ChatsViewModel extends ChangeNotifier {
  Future<Chat?> initializeChat({required String uid}) async {
    try {
      final chat = ChatRepository.instance.initializeChat(uid);
      return chat;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendMessage({
    required String message,
    required String receipient,
  }) async {
    try {
      await ChatRepository.instance.sendMessage(
        message: message,
        receipientId: receipient,
      );
    } catch (e) {
      rethrow;
    }
  }

  Stream<Chat?> fetchChat(String recipientId) {
    try {
      final stream = ChatRepository.instance.fetchChat(recipientId);

      return stream;
    } catch (e) {
      rethrow;
    }
  }
}
