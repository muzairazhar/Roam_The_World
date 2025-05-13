import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get Chat ID (based on sender and receiver IDs)
  Future<String> getChatId(String currentUserId, String otherUserId) async {
    // Get the chat document ID using sender and receiver IDs
    final chatSnapshot = await _firestore.collection('chats')
        .where('users', arrayContains: currentUserId)
        .where('users', arrayContains: otherUserId)
        .get();

    if (chatSnapshot.docs.isNotEmpty) {
      return chatSnapshot.docs.first.id;  // Return the existing chatId
    } else {
      // If no chat exists, create a new one
      final chatRef = await _firestore.collection('chats').add({
        'users': [currentUserId, otherUserId],
        'createdAt': FieldValue.serverTimestamp(),
      });

      return chatRef.id;  // Return the new chatId
    }
  }

  // Send message to Firestore
  Future<Future<DocumentReference<Map<String, dynamic>>>> sendMessage(String chatId, String senderId, String text) async {
    try {
      final messageRef = _firestore.collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return messageRef;  // Message sent successfully
    } catch (e) {
      throw Exception("Failed to send message: $e");
    }
  }

  // Stream messages in real-time
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore.collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)  // Sort messages by timestamp
        .snapshots();
  }
}
