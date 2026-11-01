import 'package:equatable/equatable.dart';

import '../../../domain/entities/Hadith.dart';
import '../../../domain/entities/Ziker.dart';

// Declared in priority order: results are sorted by this index
enum SearchMatchField { zikerTitle, hadithTitle, hadithContent }

extension SearchMatchFieldLabel on SearchMatchField {
  String get label {
    switch (this) {
      case SearchMatchField.zikerTitle:
        return 'عنوان الذكر';
      case SearchMatchField.hadithTitle:
        return 'عنوان الحديث';
      case SearchMatchField.hadithContent:
        return 'نص الحديث';
    }
  }
}

class SearchResult extends Equatable {
  final Ziker ziker;
  final int type; // same type used by MainScreen / ZikerScreen
  final Hadith? hadith; // null when the ziker title matched
  final int hadithIndex;
  final SearchMatchField field;
  final String text; // the matched field text
  final int matchStart; // match range inside [text]
  final int matchEnd;

  const SearchResult({
    required this.ziker,
    required this.type,
    required this.hadith,
    required this.hadithIndex,
    required this.field,
    required this.text,
    required this.matchStart,
    required this.matchEnd,
  });

  @override
  List<Object?> get props => [ziker.id, hadithIndex, field, matchStart];
}

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchQueryTooShortState extends SearchState {}

class SearchEmptyState extends SearchState {
  final String query;

  const SearchEmptyState(this.query);

  @override
  List<Object> get props => [query];
}

class SearchLoadedState extends SearchState {
  final String query;
  final List<SearchResult> results;

  const SearchLoadedState({required this.query, required this.results});

  @override
  List<Object> get props => [query, results];
}
