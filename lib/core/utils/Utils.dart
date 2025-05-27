import '../../features/ziker/domain/entities/Ziker.dart';
import 'FontSize.dart';

class Utils {
  Utils._privateConstructor();

 final  double small = 20;
 final  double mediam = 22;
 final  double large = 24;

  static final Utils _instance = Utils._privateConstructor();

  factory Utils() {
    return _instance;
  }

  double fontSize(dynamic input) {
    if (input is int) {
      switch (input) {
        case 1:
          return small;
        case 2:
          return mediam;
        case 3:
          return large;
      }
    } else if (input is FontSize) {
      switch (input) {
        case FontSize.Small :
          return small;
        case FontSize.Median:
          return mediam;
        case FontSize.Large:
          return large;
      }
    }
    return 20;
  }

}

extension ArabicNumberReplacement on String {
  String replaceArabicNumbers() {
    return replaceAll("1", "١")
        .replaceAll("2", "٢")
        .replaceAll("3", "٣")
        .replaceAll("4", "٤")
        .replaceAll("5", "٥")
        .replaceAll("6", "٦")
        .replaceAll("7", "٧")
        .replaceAll("8", "٨")
        .replaceAll("9", "٩")
        .replaceAll("0", "٠")
        .replaceAll("AM", "صباحاً")
        .replaceAll("PM", "مسائاً");
  }
}
extension ReplaceArabicString on int {
  String replaceArabicString() {
    switch (this) {
      case 1:
        return "مرة واحدة";
      case 2:
        return "مرتان";
      case 3:
        return "ثلاث مرات";
      case 7:
        return "سبع مرات";
      case 10:
        return "عشر مرات";
      case 33:
        return "ثلاث وثلاثون مرة";
      case 34:
        return "اربعة وثلاثون مرة";
      case 100:
        return "مئة مرة";
      default:
        return "مرة واحدة";
    }
  }
}
extension RemoveNumberInParentheses on String {
  String removeNumberInParentheses() {
    // Regular expression to match (number) pattern
    RegExp regExp = RegExp(r'\(\d+\)');

    // Replace all occurrences with empty string
    return this.replaceAll(regExp, '');
  }
}

String getTitle(int type) {
  if(type == 1)return 'الأذكار اليومية';
  else if (type == 2)return 'القراءة في الصلوات';
  else if (type == 3)return 'دليل الحج';
  else return 'دليل العمرة';
}

