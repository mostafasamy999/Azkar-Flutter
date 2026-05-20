import 'package:flutter/material.dart';
import '../../domain/entities/social_link_entity.dart';

class SocialButtonWidget extends StatelessWidget {
  const SocialButtonWidget({
    required this.social,
    required this.onTap,
    super.key,
  });

  final SocialLinkEntity social;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(_getIconData(social.platform), color: Colors.white),
      label: Text(
        social.title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1D3557),
        minimumSize: const Size(280, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  IconData _getIconData(String platform) {
    switch (platform.toLowerCase()) {
      case 'telegram':
        return Icons.telegram;
      case 'whatsapp':
        return Icons.chat;
      case 'facebook':
        return Icons.facebook;
      case 'youtube':
        return Icons.play_circle_fill;
      default:
        return Icons.link;
    }
  }
}