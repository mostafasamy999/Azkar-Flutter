import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

import '../../../../core/colors.dart';
import '../../../../core/utils/FontSize.dart';
import '../../../../core/utils/Utils.dart';
import '../../../ziker/domain/entities/Hadith.dart';

/// Every surah but Al-Fatiha (its ayah 1 IS the basmala) and At-Tawbah
/// (recited with no basmala) has this text glued to the front of ayah 1
/// with no separator, so it must be stripped out and shown on its own.
final String _bismillahPrefix = quran.getVerse(1, 1);

/// Shows only the ayat a hadith refers to, not the full Quran page.
class NewPartQuranScreen extends StatelessWidget {
  final List<QuranReference> references;

  const NewPartQuranScreen({
    Key? key,
    required this.references,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fontSize = Utils().fontSize(FontSize.Median);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            references.length == 1
                ? quran.getSurahNameArabic(references.first.surahNumber)
                : 'الآيات',
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
              for (final reference in references) ...[
                if (references.length > 1)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 8),
                    child: Text(
                      quran.getSurahNameArabic(reference.surahNumber),
                      style: TextStyle(
                        fontSize: fontSize + 2,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                if (reference.startAyah == 1 &&
                    reference.surahNumber != 1 &&
                    reference.surahNumber != 9)
                  _BismillahHeader(fontSize: fontSize),
                for (int ayah = reference.startAyah;
                    ayah <= reference.endAyah;
                    ayah++)
                  _AyahContainer(
                    surahNumber: reference.surahNumber,
                    ayahNumber: ayah,
                    fontSize: fontSize,
                  ),
              ],
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
    var text = quran.getVerse(surahNumber, ayahNumber);
    if (ayahNumber == 1 && surahNumber != 1 && text.startsWith(_bismillahPrefix)) {
      text = text.substring(_bismillahPrefix.length).trimLeft();
    }
    final style = TextStyle(
      fontSize: fontSize,
      height: 1.8,
      fontFamily: 'scheherazade-medium',
      color: AppColors.textPrimary,
    );
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.textBg.withValues(alpha: 0.2)),
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: text, style: style),
            const WidgetSpan(child: SizedBox(width: 6)),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _AyahEndMarker(ayahNumber: ayahNumber, fontSize: fontSize),
            ),
          ],
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}

class _BismillahHeader extends StatelessWidget {
  final double fontSize;

  const _BismillahHeader({required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 12),
      child: Text(
        _bismillahPrefix,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize + 2,
          fontFamily: 'scheherazade-medium',
          color: AppColors.primary,
        ),
      ),
    );
  }
}

/// Draws the ۝ end-of-ayah ornament with the ayah number centered inside it.
/// The Scheherazade font has no glyph shaping for that sequence, so plain
/// text renders the number after the symbol instead of nested in it.
class _AyahEndMarker extends StatelessWidget {
  final int ayahNumber;
  final double fontSize;

  const _AyahEndMarker({required this.ayahNumber, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          '۝',
          style: TextStyle(
            fontSize: fontSize * 1.3,
            fontFamily: 'scheherazade-medium',
            color: AppColors.primary,
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 2),
          child: Text(
            '$ayahNumber'.replaceArabicNumbers(),
            style: TextStyle(
              fontSize: fontSize * 0.4,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
