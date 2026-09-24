import 'package:equatable/equatable.dart';

class QuranReference extends Equatable {
  final int surahNumber;
  final int startAyah;
  final int endAyah;

  const QuranReference({
    required this.surahNumber,
    required this.startAyah,
    required this.endAyah,
  });

  @override
  List<Object?> get props => [surahNumber, startAyah, endAyah];
}

class Hadith extends Equatable {
  final int id;
  final String matn;
  final String isnad;
  final int no_repeat;
  int state;
  final bool hasTitle ;
  final List<QuranReference>? quranReferences;

  Hadith(this.id, this.matn, this.isnad, this.no_repeat, this.state,
      this.hasTitle, {
        this.quranReferences,
      });

  bool get hasQuranReference => quranReferences != null && quranReferences!.isNotEmpty;

  @override
  List<Object?> get props => [id, matn, isnad, no_repeat, state, hasTitle, quranReferences];
}
