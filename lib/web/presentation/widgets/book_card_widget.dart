import 'package:flutter/material.dart';
import '../../domain/entities/book_entity.dart';

class BookCardWidget extends StatelessWidget {
  const BookCardWidget({
    required this.book,
    required this.onDownloadTap,
    super.key,
  });

  final BookEntity book;
  final VoidCallback onDownloadTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                book.coverImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.book, size: 50, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onDownloadTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F4C5C),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 12),
          ),
          child: Text(
            'اضغط لتحميل الكتاب',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}