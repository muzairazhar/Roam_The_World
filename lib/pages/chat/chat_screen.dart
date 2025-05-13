import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:roam_the_world_app/pages/chat/chat_room_screen.dart';
import 'package:roam_the_world_app/routes/app_routes.dart';
import 'package:roam_the_world_app/utils/app_colors.dart';

class ChatScreen extends StatefulWidget {
  final String currentUsername;
  final Map<String, dynamic>? userMap;
  final Map<String, dynamic>? postMap;
  final String? chatRoomId;

  ChatScreen({required this.currentUsername,this.chatRoomId,
    this.userMap,this.postMap});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late Map<String, dynamic> postData;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String chatRoomId(String user1, String user2) {
  //   if (user1[0].toLowerCase().codeUnits[0] >
  //       user2.toLowerCase().codeUnits[0]) {
  //     return "$user1$user2";
  //   } else {
  //     return "$user2$user1";
  //   }
  // }
  // Future<void> fetchPostData() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection('posts')
  //       .doc(widget.postid)
  //       .get();
  //
  //   if (snapshot.exists) {
  //     setState(() {
  //       postData = snapshot.data()!;
  //     });
  //   }
  // }
  final userId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kWhiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          "Chats",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .where('lastMessageBy', isNotEqualTo: null)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final chatDocs = snapshot.data!.docs.where((doc) {
            final id = doc.id;
            return id.contains(widget.currentUsername);
          }).toList();

          if (chatDocs.isEmpty) return Center(child: Text("No chats yet"));

          return ListView.separated(
            padding: EdgeInsets.all(20),
            itemCount: chatDocs.length,
            separatorBuilder: (_, __) => Divider(color: AppColors.kBorderColor.withOpacity(0.5)),
            itemBuilder: (context, index) {
              final data = chatDocs[index].data() as Map<String, dynamic>;
              final docId = chatDocs[index].id;

              final participants = docId.split("_");
              final otherUser = participants.firstWhere((name) => name != widget.currentUsername);

              // 🟢 check if current user has unread messages
              final unreadBy = List<String>.from(data['unreadBy'] ?? []);
              final isUnread = unreadBy.contains(widget.currentUsername);

              return ListTile(
                onTap: () {
                  // ✅ Remove current user from unreadBy when tapping chat
                  FirebaseFirestore.instance
                      .collection('chatroom')
                      .doc(docId)
                      .update({
                    'unreadBy': FieldValue.arrayRemove([widget.currentUsername]),
                  });

                 Get.to(
                     ChatRoomScreen(
                   postMap: widget.postMap,
                   recivername: data['other_user'],
                   chatRoomId: 'WaseemMuhammad',
                   userMap: widget.userMap,
                    currentusername: widget.currentUsername,

                 ));

                },
                leading: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
                title: Text(
                  data['other_user'] ?? otherUser,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.kTextColor,
                  ),
                ),
                subtitle: Text(
                  data['lastMessage'] ?? "",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.kTextColor.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (data['lastMessageTime'] != null)
                      Text(
                        DateFormat('hh:mm a').format((data['lastMessageTime'] as Timestamp).toDate()),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.kTextColor.withOpacity(0.6),
                        ),
                      ),
                    if (isUnread)
                      Container(
                        margin: EdgeInsets.only(top: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              );

            },
          );
        },
      ),
    );
  }
}
