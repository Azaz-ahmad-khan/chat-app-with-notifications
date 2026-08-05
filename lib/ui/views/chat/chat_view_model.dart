//lib\ui\views\chat\chat_view_model.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noti_chat/core/models/message_model.dart';
import 'package:noti_chat/core/services/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  ChatService chatService = ChatService();
  TextEditingController messageController = TextEditingController();
  Stream<List<Map<String, dynamic>>> getMessages(
    String currentUserId,
    String receiverId,
  ) {
    return chatService.getMessages(currentUserId, receiverId);
  }

  Future<void> sendMessage(
    String senderId,
    String receiverId,
    MessageModel message,
  ) async {
    isLoading = true;
    notifyListeners();
    try {
      await chatService.sendMessage(senderId, receiverId, message);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setUnreadCountToZero(
    String currentUserId,
    String otherUserId,
  ) async {
    try {
      await chatService.setUnreadToZero(currentUserId, otherUserId);
    } catch (e) {
      errorMessage = e.toString();
    }
  }
}
