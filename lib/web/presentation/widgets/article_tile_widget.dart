import 'package:flutter/material.dart';
import '../../domain/entities/article_entity.dart';

class ArticleTileWidget extends StatelessWidget {
  const ArticleTileWidget({
    required this.article,
    required this.onTap,
    super.key,
  });

  final ArticleEntity article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsetsDirectional.symmetric(vertical: 6),
        padding: const EdgeInsetsDirectional.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF005F73),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF0A9396), width: 1),
        ),
        child: Text(
          article.title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}