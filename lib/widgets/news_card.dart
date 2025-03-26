import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../views/article_page.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: article.imageUrl.isNotEmpty
            ? Image.network(article.imageUrl, width: 80, fit: BoxFit.cover)
            : SizedBox(width: 80), 
        title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(article.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticlePage(article: article),
            ),
          );
        },
      ),
    );
  }
}
