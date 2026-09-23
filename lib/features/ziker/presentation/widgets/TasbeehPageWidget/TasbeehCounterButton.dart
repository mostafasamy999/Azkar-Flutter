import 'package:flutter/material.dart';

import '../../../../../core/colors.dart';
import '../../../../../core/utils/Utils.dart';

class TasbeehCounterButton extends StatelessWidget {
  final int count;

  const TasbeehCounterButton({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 220,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primary],
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        '$count'.replaceArabicNumbers(),
        style: const TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
