import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/chat_message_model.dart';

class ChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create or get Chat Room ID (always between two users)
  String getChatRoomId(String user1, String user2) {
    if (user1.hashCode <= user2.hashCode) {
      return '$user1\_$user2';
    } else {
      return '$user2\_$user1';
    }
  }

  // Send a new message
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String messageText,
    String? imageUrl,
  }) async
  {
    try {
      String chatRoomId = getChatRoomId(senderId, receiverId);

      ChatMessage chatMessage = ChatMessage(
        senderId: senderId,
        receiverId: receiverId,
        timestamp: DateTime.now(),
        text: '',
      );

      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(chatMessage.toJson());
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> userclick({
    required String senderId,
    required String receiverId,
    required String messageText,
    String? imageUrl,
  }) async
  {
    try {
      String chatRoomId = getChatRoomId(senderId, receiverId);

      ChatMessage chatMessage = ChatMessage(
        senderId: senderId,
        receiverId: receiverId,
        timestamp: DateTime.now(),
        text: '',
      );

      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(chatMessage.toJson());
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  // Get all messages as a Stream (to update chat screen live)
  Stream<List<ChatMessage>> getMessages(String senderId, String receiverId) {
    String chatRoomId = getChatRoomId(senderId, receiverId);

    return _firestore
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => ChatMessage.fromJson(doc.data())).toList());
  }
}





