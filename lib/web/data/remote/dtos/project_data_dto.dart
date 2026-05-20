import '../../../domain/entities/author_entity.dart';
import '../../../domain/entities/book_entity.dart';
import '../../../domain/entities/article_entity.dart';
import '../../../domain/entities/social_link_entity.dart';

class ProjectDataDto {
  ProjectDataDto({
    this.author,
    this.booksSection,
    this.articlesSection,
    this.applicationsSection,
    this.socialMedia,
  });

  factory ProjectDataDto.fromJson(Map<String, dynamic> json) => ProjectDataDto(
    author: json['author'] != null ? AuthorDto.fromJson(json['author']) : null,
    booksSection: json['books_section'] != null ? SectionDto.fromJson(json['books_section']) : null,
    articlesSection: json['articles_section'] != null ? SectionDto.fromJson(json['articles_section']) : null,
    applicationsSection: json['applications_section'] != null ? SectionDto.fromJson(json['applications_section']) : null,
    socialMedia: json['social_media'] != null ? SocialMediaSectionDto.fromJson(json['social_media']) : null,
  );

  final AuthorDto? author;
  final SectionDto? booksSection;
  final SectionDto? articlesSection;
  final SectionDto? applicationsSection;
  final SocialMediaSectionDto? socialMedia;
}

class AuthorDto {
  AuthorDto({this.name, this.profileImage});
  factory AuthorDto.fromJson(Map<String, dynamic> json) => AuthorDto(
    name: json['name'] as String?,
    profileImage: json['profile_image'] as String?,
  );
  final String? name;
  final String? profileImage;
}

class SectionDto {
  SectionDto({this.title, this.items});
  factory SectionDto.fromJson(Map<String, dynamic> json) => SectionDto(
    title: json['title'] as String?,
    items: json['items'] != null
        ? List<ItemDto>.from((json['items'] as List).map((x) => ItemDto.fromJson(x)))
        : null,
  );
  final String? title;
  final List<ItemDto>? items;
}

class ItemDto {
  ItemDto({this.id, this.title, this.subtitle, this.authorName, this.coverImage, this.iconImage, this.downloadUrl, this.url});
  factory ItemDto.fromJson(Map<String, dynamic> json) => ItemDto(
    id: json['id'] as String?,
    title: json['title'] as String?,
    subtitle: json['subtitle'] as String?,
    authorName: json['author_name'] as String?,
    coverImage: json['cover_image'] as String?,
    iconImage: json['icon_image'] as String?,
    downloadUrl: json['download_url'] as String?,
    url: json['url'] as String?,
  );
  final String? id;
  final String? title;
  final String? subtitle;
  final String? authorName;
  final String? coverImage;
  final String? iconImage;
  final String? downloadUrl;
  final String? url;
}

class SocialMediaSectionDto {
  SocialMediaSectionDto({this.title, this.links});
  factory SocialMediaSectionDto.fromJson(Map<String, dynamic> json) => SocialMediaSectionDto(
    title: json['title'] as String?,
    links: json['links'] != null
        ? List<SocialLinkDto>.from((json['links'] as List).map((x) => SocialLinkDto.fromJson(x)))
        : null,
  );
  final String? title;
  final List<SocialLinkDto>? links;
}

class SocialLinkDto {
  SocialLinkDto({this.platform, this.title, this.url});
  factory SocialLinkDto.fromJson(Map<String, dynamic> json) => SocialLinkDto(
    platform: json['platform'] as String?,
    title: json['title'] as String?,
    url: json['url'] as String?,
  );
  final String? platform;
  final String? title;
  final String? url;
}

// ── Domain Layer Extensions ───────────────────────────────────────────
extension ProjectDataMapping on ProjectDataDto {
  AuthorEntity toAuthorEntity() => AuthorEntity(
    name: author?.name ?? '',
    profileImage: author?.profileImage ?? '',
  );

  List<BookEntity> toBookEntities() {
    return booksSection?.items?.map((item) => BookEntity(
      id: item.id ?? '',
      title: item.title ?? '',
      subtitle: item.subtitle,
      authorName: item.authorName ?? '',
      coverImage: item.coverImage ?? '',
      downloadUrl: item.downloadUrl ?? '',
    )).toList() ?? [];
  }

  List<ArticleEntity> toArticleEntities() {
    return articlesSection?.items?.map((item) => ArticleEntity(
      id: item.id ?? '',
      title: item.title ?? '',
      url: item.url ?? '',
    )).toList() ?? [];
  }

  List<SocialLinkEntity> toSocialEntities() {
    return socialMedia?.links?.map((item) => SocialLinkEntity(
      platform: item.platform ?? '',
      title: item.title ?? '',
      url: item.url ?? '',
    )).toList() ?? [];
  }
}