import 'package:flutter/material.dart';

class SectionHeaderWidget extends StatelessWidget {
  const SectionHeaderWidget({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.symmetric(vertical: 24),
      padding: const EdgeInsetsDirectional.fromSTEB(32, 12, 32, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D787A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF5CE1E6), width: 2),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}