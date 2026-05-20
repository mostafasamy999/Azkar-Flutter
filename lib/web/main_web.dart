import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sahih_azkar/web/presentation/screens/home/home_screen.dart';
import 'data/remote/dtos/project_data_dto.dart';
import 'domain/entities/article_entity.dart';
import 'domain/entities/author_entity.dart';
import 'domain/entities/book_entity.dart';
import 'domain/entities/social_link_entity.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'الكتب والمؤلفات',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const InitializationScreen(),
    );
  }
}

class InitializationScreen extends StatelessWidget {
  const InitializationScreen({super.key});

  Future<Map<String, dynamic>> _loadProjectData() async {
    // Loads the local JSON configurations asset configuration mapping file safely
    final String jsonString = await rootBundle.loadString('assets/data/project_data.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;

    // Parse using untrusted DTO models
    final projectDto = ProjectDataDto.fromJson(jsonMap);

    // Transform directly to pure Immutable Domain Entities via Layer Extensions
    return {
      'author': projectDto.toAuthorEntity(),
      'books': projectDto.toBookEntities(),
      'articles': projectDto.toArticleEntities(),
      'socialLinks': projectDto.toSocialEntities(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadProjectData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D787A)),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Text(
                'خطأ في تحميل البيانات. يرجى التأكد من ملف project_data.json',
              ),
            ),
          );
        }

        final data = snapshot.data!;

        return HomeScreen(
          author: data['author'] as AuthorEntity,
          books: data['books'] as List<BookEntity>,
          articles: data['articles'] as List<ArticleEntity>,
          socialLinks: data['socialLinks'] as List<SocialLinkEntity>,
        );
      },
    );
  }
}