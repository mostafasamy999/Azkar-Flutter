import 'package:equatable/equatable.dart';

import '../../domain/entities/Hadith.dart';

class HadithResponse extends Hadith {
  HadithResponse(
      int id,
      String matn,
      String isnad,
      int no_repeat,
      int state,
      {bool hasTitle = false,
      int? quranSurahNumber,
      int? quranStartAyah,
      int? quranEndAyah})
      : super(id, matn, isnad, no_repeat, state, hasTitle,
            quranSurahNumber: quranSurahNumber,
            quranStartAyah: quranStartAyah,
            quranEndAyah: quranEndAyah);
}
