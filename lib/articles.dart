import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  final dynamic article;

  const ArticlePage({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Artikel & Berita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article['title'],
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              article['content'],
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 16.0),
            Image.network(
              article['img_url'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}

class AllArticlesPage extends StatelessWidget {
  final List<dynamic> articles;

  const AllArticlesPage({required this.articles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artikel & Tips'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20.0),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          final article = articles[index];
          return GestureDetector(
            onTap: () {
              navigateToArticlePage(context, article);
            },
            child: Card(
              elevation: 4.0,
              margin: EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      article['img_url'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      article['title'],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      article['content'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void navigateToArticlePage(BuildContext context, dynamic article) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ArticlePage(article: article),
    ),
  );
}
