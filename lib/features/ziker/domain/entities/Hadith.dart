import 'package:equatable/equatable.dart';

class Hadith extends Equatable {
  final int id;
  final String matn;
  final String isnad;
  final int no_repeat;
  int state;
  final bool hasTitle ;
  final int? quranSurahNumber;
  final int? quranStartAyah;
  final int? quranEndAyah;

  Hadith(this.id, this.matn, this.isnad, this.no_repeat, this.state,
      this.hasTitle, {
        this.quranSurahNumber,
        this.quranStartAyah,
        this.quranEndAyah,
      });

  bool get hasQuranReference => quranSurahNumber != null && quranStartAyah != null && quranEndAyah != null;

  @override
  List<Object?> get props => [id, matn, isnad, no_repeat, state, hasTitle, quranSurahNumber, quranStartAyah, quranEndAyah];
}
