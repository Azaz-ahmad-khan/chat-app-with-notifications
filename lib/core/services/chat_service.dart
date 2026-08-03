//lib\core\services\chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noti_chat/core/models/message_model.dart';

class ChatService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> sendMessage(
    String currentUserId,
    String ReceiverId,
    MessageModel message,
  ) async {
    try {
      List<String> ids = [currentUserId, ReceiverId];
      ids.sort();
      final chatRoomId = ids.join('-');
      await firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toMap());
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception('could not send Message');
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages(
    String currentUserId,
    String otherUserId,
  ) {
    List<String> ids = [currentUserId, otherUserId];
    ids.sort();
    final chatRoomId = ids.join('-');

    return firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sendingTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return doc.data();
          }).toList();
        });
  }
}
