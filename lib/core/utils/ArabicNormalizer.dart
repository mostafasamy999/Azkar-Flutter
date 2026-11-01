// Normalizes Arabic text for searching, so "الصبر" matches "الصَّبْرِ", "أ" matches "ا", etc.
class NormalizedText {
  final String text;

  // originalIndex[i] = index in the original string of normalized char i
  final List<int> originalIndex;

  const NormalizedText(this.text, this.originalIndex);
}

class ArabicNormalizer {
  ArabicNormalizer._();

  static const _letterMap = {
    'أ': 'ا',
    'إ': 'ا',
    'آ': 'ا',
    'ٱ': 'ا',
    'ى': 'ي',
    'ئ': 'ي',
    'ؤ': 'و',
    'ة': 'ه',
  };

  static bool isIgnored(int code) =>
      (code >= 0x064B && code <= 0x065F) || // harakat (tashkeel)
      code == 0x0670 || // superscript alef
      code == 0x0640 || // tatweel
      (code >= 0x06D6 && code <= 0x06ED) || // quranic marks
      (code >= 0x200B && code <= 0x200F); // zero-width / direction marks

  static NormalizedText normalizeWithMap(String input) {
    final buffer = StringBuffer();
    final indexes = <int>[];
    bool lastWasSpace = true; // trims leading spaces

    for (int i = 0; i < input.length; i++) {
      final code = input.codeUnitAt(i);
      if (isIgnored(code)) continue;

      final char = input[i];
      if (char.trim().isEmpty) {
        if (lastWasSpace) continue;
        buffer.write(' ');
        indexes.add(i);
        lastWasSpace = true;
        continue;
      }

      buffer.write(_letterMap[char] ?? char.toLowerCase());
      indexes.add(i);
      lastWasSpace = false;
    }

    var text = buffer.toString();
    if (text.endsWith(' ')) {
      text = text.substring(0, text.length - 1);
      indexes.removeLast();
    }
    return NormalizedText(text, indexes);
  }

  static String normalize(String input) => normalizeWithMap(input).text;
}
