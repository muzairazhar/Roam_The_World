import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  final String senderId;     // Who sent the message
  final String receiverId;   // Who received the message
  final String message;      // The actual chat text
  final String? imageUrl;    // Optional (if sending images)
  final DateTime timestamp;  // When message was sent

  ChatMessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.imageUrl,
    required this.timestamp,
  });

  // Create ChatMessage from Firestore document (Map)
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      imageUrl: json['imageUrl'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert ChatMessage to Map (for uploading to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
    };
  }
}
