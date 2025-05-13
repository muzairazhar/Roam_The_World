import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullProfileImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullProfileImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.95),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: 'profile_${ModalRoute.of(context)?.settings.arguments ?? 'default'}',
            child: CircleAvatar(
              radius: 120,
              backgroundImage: CachedNetworkImageProvider(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
