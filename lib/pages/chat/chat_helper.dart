// lib/pages/chat/chat_helper.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chat_room_screen.dart';

Future<void> openChat(BuildContext context, String currentUserId, String postOwnerId) async {
  final chatCollection = FirebaseFirestore.instance.collection('chats');

  // Check if chat already exists
  final existingChats = await chatCollection
      .where('participants', arrayContains: currentUserId)
      .get();

  String? chatId;

  for (var doc in existingChats.docs) {
    final participants = List<String>.from(doc['participants']);
    if (participants.contains(postOwnerId)) {
      chatId = doc.id;
      break;
    }
  }

  // If not found, create new
  if (chatId == null) {
    final docRef = await chatCollection.add({
      'participants': [currentUserId, postOwnerId],
      'createdAt': Timestamp.now(),
    });
    chatId = docRef.id;
  }

  // Navigate to chat room screen
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => ChatRoomScreen(
      ),
    ),
  );
}
