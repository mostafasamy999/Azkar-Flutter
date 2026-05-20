import 'package:equatable/equatable.dart';

class SocialLinkEntity extends Equatable {
  const SocialLinkEntity({
    required this.platform,
    required this.title,
    required this.url,
  });

  final String platform;
  final String title;
  final String url;

  SocialLinkEntity copyWith({
    String? platform,
    String? title,
    String? url,
  }) => SocialLinkEntity(
    platform: platform ?? this.platform,
    title: title ?? this.title,
    url: url ?? this.url,
  );

  @override
  List<Object?> get props => [platform, title, url];
}