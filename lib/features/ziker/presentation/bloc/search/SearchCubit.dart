import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/ArabicNormalizer.dart';
import '../../../../../core/utils/Utils.dart';
import '../../../domain/entities/Hadith.dart';
import '../../../domain/entities/Ziker.dart';
import 'SearchState.dart';

class _IndexedField {
  final Ziker ziker;
  final int type;
  final Hadith? hadith;
  final int hadithIndex;
  final SearchMatchField field;
  final String text;
  final NormalizedText normalized;

  _IndexedField({
    required this.ziker,
    required this.type,
    required this.hadith,
    required this.hadithIndex,
    required this.field,
    required this.text,
  }) : normalized = ArabicNormalizer.normalizeWithMap(text);
}

class SearchCubit extends Cubit<SearchState> {
  static const _debounce = Duration(milliseconds: 300);
  static const _minQueryLength = 2;

  final List<_IndexedField> _index = [];
  Timer? _debounceTimer;

  SearchCubit() : super(SearchInitial());

  // Used once when the search screen opens: normalizes every ziker title,
  // hadith title and hadith content a single time, so typing only does
  // substring checks on cached text.
  // [azkarByType] uses the same types as MainScreen (1..4); a ziker found in
  // several lists is indexed once, under its first type.
  void buildIndex(Map<int, List<Ziker>> azkarByType) {
    _index.clear();
    final seenIds = <int>{};

    for (final entry in azkarByType.entries) {
      for (final ziker in entry.value) {
        if (!seenIds.add(ziker.id)) continue;

        _index.add(_IndexedField(
          ziker: ziker,
          type: entry.key,
          hadith: null,
          hadithIndex: 0,
          field: SearchMatchField.zikerTitle,
          text: ziker.name.removeNumberInParentheses().trim(),
        ));

        for (int i = 0; i < ziker.arr.length; i++) {
          final hadith = ziker.arr[i];
          if (hadith.hasTitle) {
            _index.add(_IndexedField(
              ziker: ziker,
              type: entry.key,
              hadith: hadith,
              hadithIndex: i,
              field: SearchMatchField.hadithTitle,
              text: hadith.title.removeNumberInParentheses().trim(),
            ));
          }
          _index.add(_IndexedField(
            ziker: ziker,
            type: entry.key,
            hadith: hadith,
            hadithIndex: i,
            field: SearchMatchField.hadithContent,
            text: hadith.content.removeNumberInParentheses().trim(),
          ));
        }
      }
    }
  }

  // Used on every keystroke in the search field: waits until the user
  // pauses typing before running the search.
  void onQueryChanged(String query) {
    _debounceTimer?.cancel();
    if (query.trim().isEmpty) {
      emit(SearchInitial());
      return;
    }
    _debounceTimer = Timer(_debounce, () => _search(query));
  }

  // Used when the user taps the clear button in the search field.
  void clear() {
    _debounceTimer?.cancel();
    emit(SearchInitial());
  }

  void _search(String query) {
    final normalizedQuery = ArabicNormalizer.normalize(query);
    if (normalizedQuery.isEmpty) {
      emit(SearchInitial());
      return;
    }
    if (normalizedQuery.length < _minQueryLength) {
      emit(SearchQueryTooShortState());
      return;
    }

    final results = <SearchResult>[];
    // a hadith that matches in its title and its content is shown once,
    // under the higher-priority field
    final matchedHadiths = <String>{};

    for (final field in SearchMatchField.values) {
      for (final item in _index) {
        if (item.field != field) continue;

        final start = item.normalized.text.indexOf(normalizedQuery);
        if (start == -1) continue;

        if (item.hadith != null &&
            !matchedHadiths.add('${item.ziker.id}-${item.hadithIndex}')) {
          continue;
        }

        final map = item.normalized.originalIndex;
        int matchEnd = map[start + normalizedQuery.length - 1] + 1;
        // keep the last letter's tashkeel inside the highlight
        while (matchEnd < item.text.length &&
            ArabicNormalizer.isIgnored(item.text.codeUnitAt(matchEnd))) {
          matchEnd++;
        }
        results.add(SearchResult(
          ziker: item.ziker,
          type: item.type,
          hadith: item.hadith,
          hadithIndex: item.hadithIndex,
          field: item.field,
          text: item.text,
          matchStart: map[start],
          matchEnd: matchEnd,
        ));
      }
    }

    emit(results.isEmpty
        ? SearchEmptyState(query.trim())
        : SearchLoadedState(query: query.trim(), results: results));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
