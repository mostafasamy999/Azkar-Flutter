import 'package:flutter/material.dart';
import '../../../domain/entities/author_entity.dart';
import '../../../domain/entities/book_entity.dart';
import '../../../domain/entities/article_entity.dart';
import '../../../domain/entities/social_link_entity.dart';
import '../../widgets/section_header_widget.dart';
import '../../widgets/book_card_widget.dart';
import '../../widgets/article_tile_widget.dart';
import '../../widgets/social_button_widget.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/author_entity.dart';
import '../../../domain/entities/book_entity.dart';
import '../../../domain/entities/article_entity.dart';
import '../../../domain/entities/social_link_entity.dart';
import '../../widgets/section_header_widget.dart';
import '../../widgets/book_card_widget.dart';
import '../../widgets/article_tile_widget.dart';
import '../../widgets/social_button_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.author,
    required this.books,
    required this.articles,
    required this.socialLinks,
    super.key,
  });

  final AuthorEntity author;
  final List<BookEntity> books;
  final List<ArticleEntity> articles;
  final List<SocialLinkEntity> socialLinks;

  Future<void> _openUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE0F2F1), Color(0xFFB2DFDB), Color(0xFF80DEEA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1024),
                child: CustomScrollView(
                  slivers: [
                    // ── Author Header ─────────────────────────────────
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(top: 32, bottom: 16),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: AssetImage(author.profileImage),
                              backgroundColor: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              author.name,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F4C5C),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Books Section ─────────────────────────────────
                    const SliverToBoxAdapter(
                      child: SectionHeaderWidget(title: 'الكتب والمؤلفات'),
                    ),
                    SliverPadding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.65,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) => BookCardWidget(
                            book: books[index],
                            onDownloadTap: () => _openUrl(books[index].downloadUrl),
                          ),
                          childCount: books.length,
                        ),
                      ),
                    ),

                    // ── Articles Section ──────────────────────────────
                    const SliverToBoxAdapter(
                      child: SectionHeaderWidget(title: 'المقالات والمنشورات'),
                    ),
                    SliverPadding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) => ArticleTileWidget(
                            article: articles[index],
                            onTap: () => _openUrl(articles[index].url),
                          ),
                          childCount: articles.length,
                        ),
                      ),
                    ),

                    // ── Social Media Section ──────────────────────────
                    const SliverToBoxAdapter(
                      child: SectionHeaderWidget(title: 'وسائل التواصل والقنوات'),
                    ),
                    SliverPadding(
                      padding: const EdgeInsetsDirectional.only(start: 24,end: 24, bottom: 48),
                      sliver: SliverToBoxAdapter(
                        child: Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          alignment: WrapAlignment.center,
                          children: socialLinks.map((social) => SocialButtonWidget(
                            social: social,
                            onTap: () => _openUrl(social.url),
                          )).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}