import 'package:equatable/equatable.dart';

class BookEntity extends Equatable {
  const BookEntity({
    required this.id,
    required this.title,
    this.subtitle,
    required this.authorName,
    required this.coverImage,
    required this.downloadUrl,
  });

  final String id;
  final String title;
  final String? subtitle;
  final String authorName;
  final String coverImage;
  final String downloadUrl;

  BookEntity copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? authorName,
    String? coverImage,
    String? downloadUrl,
  }) => BookEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle ?? this.subtitle,
    authorName: authorName ?? this.authorName,
    coverImage: coverImage ?? this.coverImage,
    downloadUrl: downloadUrl ?? this.downloadUrl,
  );

  @override
  List<Object?> get props => [id, title, subtitle, authorName, coverImage, downloadUrl];
}