import 'package:flutter/material.dart';
import 'package:sahih_azkar/core/utils/Utils.dart';

import '../../../../../core/colors.dart';

class SpansTextWidget extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final Color? referenceColor;

  SpansTextWidget({required this.text, required this.style, this.textAlign, this.referenceColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: buildStyledText(text),
    );
  }

  /// Function to generate styled text with special formatting for numbers in parentheses
  Text buildStyledText(String text) {
    // Regex to find any numbers in parentheses like (1), (2), etc.
    final regex = RegExp(r'\((\d+)\)');

    List<InlineSpan> spans = [];
    int lastMatchEnd = 0;

    // Find all matches of numbers in parentheses
    for (Match match in regex.allMatches(text)) {
      // Add text before the current match
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start).replaceArabicNumbers(),
          style: style,
        ));
      }

      // Add the number in parentheses with special styling
      spans.add(WidgetSpan(
        child: Transform.translate(
          offset: Offset(0, -5), // Moves number up (superscript effect)
          child: Text(
            "(${match.group(1)})".replaceArabicNumbers(),
            style: TextStyle(
              fontSize: style.fontSize! * 0.5, // Smaller size
              color: referenceColor??Colors.blue,      // Blue color
            ),
          ),
        ),
      ));

      lastMatchEnd = match.end;
    }

    // Add any remaining text after the last match
    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastMatchEnd).replaceArabicNumbers(),
        style: style,
      ));
    }

    return Text.rich(TextSpan(children: spans
    )
      ,  textAlign: textAlign??TextAlign.start,
    );
  }
}