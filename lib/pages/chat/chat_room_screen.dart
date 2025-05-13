import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roam_the_world_app/pages/chat/chat_screen.dart';
import 'package:roam_the_world_app/services/send_notification_service.dart';
import 'package:roam_the_world_app/utils/app_assets.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';

class ChatRoomScreen extends StatefulWidget {
  final Map<String, dynamic>? userMap;
  final Map<String, dynamic>? postMap;
  final String? chatRoomId;
  final String? currentusername;
  final String? recivername;

  const ChatRoomScreen({
    this.chatRoomId,
    this.userMap,
    this.currentusername,
    this.postMap,
     this.recivername,


  });

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();

  void onSendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final messageText = _messageController.text.trim();

      final token = widget.postMap!['devicetoken'];
      final receiverName = widget.postMap!['name']; // 👈 Receiver full name
      final senderName = widget.currentusername;

      // Message map
      Map<String, dynamic> message = {
        'sendby': senderName,
        'message': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      };

      final chatRoomRef = _firebase.collection('chatroom').doc(widget.chatRoomId);

      // Add message to 'chats' subcollection
      await chatRoomRef.collection('chats').add(message);

      // ✅ Update chatroom doc: add unreadBy array
      await chatRoomRef.set({
        'lastMessage': messageText,
        'lastMessageBy': senderName,
        'other_user': receiverName,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'unreadBy': FieldValue.arrayUnion([receiverName]), // 👈 mark unread
      }, SetOptions(merge: true));

      print("Firebase message and chatroom updated");

      // ✅ Send push notification
      SendNotificationService.sendNotificationUsingApi(
        Token: token,
        Title: widget.userMap!['fullname'],
        Body: messageText,
        Data: {"Screen": "ok"},

      );
      print("got to other screen");

      // Get.to(
      //     ChatScreen(
      //   userMap: widget.userMap,
      //   chatRoomId: widget.chatRoomId,
      //   postMap: widget.postMap,
      //   currentUsername: widget.currentusername.toString(),
      // ));

      print("Notification sent");

      _messageController.clear();
      print("Text cleared");
    } else {
      print("Enter some text");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: CachedNetworkImageProvider(
                "https://robohash.org/ccd4199abf062e84277adf15d310a9af?set=set4&bgset=&size=400x400",
              ),
            ),
            SizedBox(width: 10.0.w),
            Text(
              widget.postMap?['name'] ?? widget.recivername,
              style: GoogleFonts.poppins(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.kTextColor,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom != 0 ? 0 : 20,
        ),
        child: Column(
          children: [
            // Message stream
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firebase
                    .collection('chatroom')
                    .doc(widget.chatRoomId) // ✅ Correct usage
                    .collection('chats')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                      return _messageBubble(data['message']);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            // Message input
            Container(
              margin: const EdgeInsets.only(bottom: 20, top: 20),
              padding: EdgeInsets.only(right: 18.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.poppins(
                        color: AppColors.kWhiteColor,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20.w),
                        hintText: "Type a message",
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.poppins(
                          color: AppColors.kWhiteColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: onSendMessage,
                    child: SvgPicture.asset(
                      AppAssets.sendIcon,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageBubble(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: AppColors.kUserChatBubbleColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: AppColors.kTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
