import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/colors.dart';
import '../../../../core/utils/Utils.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../bloc/azkar/azkar/AzkarBloc.dart';
import '../bloc/search/SearchCubit.dart';
import '../bloc/search/SearchState.dart';
import '../widgets/titlePageWidget/message_display_widget.dart';
import 'ZikerScreen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<SearchCubit>(),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Color(0xFFF8F9FA),
          appBar: AppBar(
            title: Text(
              'البحث',
              style: TextStyle(fontSize: 24),
            ),
          ),
          body: BlocBuilder<AzkarBloc, AzkarState>(
            builder: (context, state) {
              if (state is LoadedAzkarState) {
                return _SearchBody(azkarState: state);
              } else if (state is ErrorAzkarState) {
                return MessageDisplayWidget(message: state.message);
              }
              return const LoadingWidget();
            },
          ),
        ),
      ),
    );
  }
}

class _SearchBody extends StatefulWidget {
  final LoadedAzkarState azkarState;

  const _SearchBody({required this.azkarState});

  @override
  State<_SearchBody> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<_SearchBody> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _buildIndex();
  }

  @override
  void didUpdateWidget(covariant _SearchBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.azkarState != widget.azkarState) {
      _buildIndex();
      context.read<SearchCubit>().onQueryChanged(_controller.text);
    }
  }

  // types match MainScreen: 1 daily, 2 pray, 3 haij, 4 omra
  void _buildIndex() {
    context.read<SearchCubit>().buildIndex({
      1: widget.azkarState.azkarWithoutPray,
      2: widget.azkarState.pryaAzkar,
      3: widget.azkarState.haijAzkar,
      4: widget.azkarState.omraAzkar,
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchField(),
        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoadedState) {
                return _ResultsList(results: state.results);
              } else if (state is SearchEmptyState) {
                return _message(
                    Icons.search_off, 'لا توجد نتائج لـ "${state.query}"');
              } else if (state is SearchQueryTooShortState) {
                return _message(Icons.keyboard, 'اكتب حرفين على الأقل للبحث');
              }
              return _message(Icons.manage_search,
                  'ابحث في عناوين الأذكار وعناوين ونصوص الأحاديث');
            },
          ),
        ),
      ],
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: _controller,
        builder: (context, value, _) {
          return TextField(
            controller: _controller,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onChanged: context.read<SearchCubit>().onQueryChanged,
            style: TextStyle(fontSize: 18),
            decoration: InputDecoration(
              hintText: 'ابحث...',
              prefixIcon: Icon(Icons.search, color: AppColors.primary),
              suffixIcon: value.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        context.read<SearchCubit>().clear();
                      },
                    ),
              filled: true,
              fillColor: AppColors.cardBackground,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _message(IconData icon, String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.textSecondary),
            SizedBox(height: 12),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  final List<SearchResult> results;

  const _ResultsList({required this.results});

  @override
  Widget build(BuildContext context) {
    // results are already sorted by field priority; a header starts each group
    final items = <Object>[];
    SearchMatchField? currentField;
    for (final result in results) {
      if (result.field != currentField) {
        currentField = result.field;
        items.add(currentField);
      }
      items.add(result);
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 16),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is SearchMatchField) {
          final count = results.where((e) => e.field == item).length;
          return _groupHeader(item, count);
        }
        return _resultItem(context, item as SearchResult);
      },
    );
  }

  Widget _groupHeader(SearchMatchField field, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Text(
        '${field.label} (${count.toString().replaceArabicNumbers()})',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _resultItem(BuildContext context, SearchResult result) {
    final isZikerTitle = result.field == SearchMatchField.zikerTitle;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        color: AppColors.cardBackground,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _openResult(context, result),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _fieldChip(result.field),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        getTitle(result.type),
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _highlightedText(result),
                if (!isZikerTitle) ...[
                  SizedBox(height: 6),
                  Text(
                    result.ziker.name.removeNumberInParentheses().trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14, color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fieldChip(SearchMatchField field) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _fieldColor(field).withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        field.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: _fieldColor(field),
        ),
      ),
    );
  }

  Color _fieldColor(SearchMatchField field) {
    switch (field) {
      case SearchMatchField.zikerTitle:
        return AppColors.primary;
      case SearchMatchField.hadithTitle:
        return AppColors.prayerColor;
      case SearchMatchField.hadithContent:
        return AppColors.hajjColor;
    }
  }

  // shows the matched part of the text highlighted; long hadith content is
  // cut to a window around the match
  Widget _highlightedText(SearchResult result) {
    const before = 40;
    const after = 100;
    final text = result.text;
    int start = 0;
    int end = text.length;
    if (result.field == SearchMatchField.hadithContent) {
      if (result.matchStart > before) {
        start = text.lastIndexOf(' ', result.matchStart - before) + 1;
      }
      if (end - result.matchEnd > after) {
        final space = text.indexOf(' ', result.matchEnd + after);
        end = space == -1 ? text.length : space;
      }
    }

    final isTitle = result.field != SearchMatchField.hadithContent;
    final baseStyle = TextStyle(
      fontSize: isTitle ? 18 : 17,
      height: 1.6,
      color: AppColors.textPrimary,
      fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
      fontFamily: isTitle ? null : 'scheherazade-medium',
    );

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          if (start > 0) TextSpan(text: '... '),
          TextSpan(text: text.substring(start, result.matchStart)),
          TextSpan(
            text: text.substring(result.matchStart, result.matchEnd),
            style: TextStyle(
              backgroundColor: AppColors.secondary.withOpacity(0.45),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: text.substring(result.matchEnd, end)),
          if (end < text.length) TextSpan(text: ' ...'),
        ],
      ),
      maxLines: isTitle ? 2 : 4,
      overflow: TextOverflow.ellipsis,
    );
  }

  void _openResult(BuildContext context, SearchResult result) {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZikerScreen(
          zikerTitle: result.ziker.name,
          type: result.type,
          initialPage: result.hadithIndex,
        ),
      ),
    );
  }
}
