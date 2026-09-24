import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

import '../../../../core/colors.dart';
import '../../../../core/utils/FontSize.dart';
import '../../../../core/utils/Utils.dart';
import '../../../ziker/presentation/widgets/ZikerPageWidget/SpansTextWidget.dart';

/// Shows only the ayat a hadith refers to, not the full Quran page.
class NewPartQuranScreen extends StatelessWidget {
  final int surahNumber;
  final int startAyah;
  final int endAyah;

  const NewPartQuranScreen({
    Key? key,
    required this.surahNumber,
    required this.startAyah,
    required this.endAyah,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize = Utils().fontSize(FontSize.Median);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            quran.getSurahNameArabic(surahNumber),
            style: const TextStyle(fontSize: 24),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int ayah = startAyah; ayah <= endAyah; ayah++)
                _AyahContainer(
                  surahNumber: surahNumber,
                  ayahNumber: ayah,
                  fontSize: fontSize,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AyahContainer extends StatelessWidget {
  final int surahNumber;
  final int ayahNumber;
  final double fontSize;

  const _AyahContainer({
    required this.surahNumber,
    required this.ayahNumber,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final text = quran.getVerse(surahNumber, ayahNumber, verseEndSymbol: true);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.textBg.withValues(alpha: 0.2)),
      ),
      child: SpansTextWidget(
        text: text,
        textAlign: TextAlign.right,
        referenceColor: AppColors.primary,
        style: TextStyle(
          fontSize: fontSize,
          height: 1.8,
          fontFamily: 'scheherazade-medium',
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
