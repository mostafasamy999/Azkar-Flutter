
import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  const ArticleEntity({
    required this.id,
    required this.title,
    required this.url,
  });

  final String id;
  final String title;
  final String url;

  ArticleEntity copyWith({
    String? id,
    String? title,
    String? url,
  }) => ArticleEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    url: url ?? this.url,
  );

  @override
  List<Object?> get props => [id, title, url];
}