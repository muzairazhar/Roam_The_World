import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// adjust import
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/postmodel.dart';

class UserPostsScreen extends StatelessWidget {
  final String userId;
  const UserPostsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final postRef = FirebaseFirestore.instance.collection('posts');

    return StreamBuilder<QuerySnapshot>(
      stream: postRef.where('uId', isEqualTo: userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No posts found.'));
        }

        final posts = snapshot.data!.docs
            .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: posts[index]);
          },
        );
      },
    );
  }
}

class PostCard extends StatelessWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          post.imageUrls.isNotEmpty
              ? ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12)),
            child: CachedNetworkImage(
              imageUrl: post.imageUrls.first,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
              const Icon(Icons.error),
            ),
          )
              : Container(height: 200, color: Colors.grey[300]),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${post.destination}, ${post.city}, ${post.province}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text("Tags: ${post.tags}"),
                const SizedBox(height: 4),
                Text("Airline: ${post.airline}"),
                const SizedBox(height: 4),
                Text("Duration: ${post.startDate} to ${post.endDate}"),
                const SizedBox(height: 8),
                Text("Experience: ${post.experience}"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
