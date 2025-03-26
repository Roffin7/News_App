import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/news_model.dart';
import 'article_page.dart';
import 'saved_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final ApiService apiService = ApiService();
  List<NewsArticle> newsList = [];
  String selectedCategory = 'general';

  final List<String> categories = [
    'general', 'business', 'sports', 'technology', 'entertainment', 'health', 'science'
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  void fetchNews() async {
    final news = await apiService.fetchNews(category: selectedCategory);
    setState(() {
      newsList = news;
    });
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SavedPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // CATEGORY LIST WITH IMPROVED SPACING
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10), // Added spacing
            child: SizedBox(
              height: 55,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                      fetchNews();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Increased padding
                      margin: const EdgeInsets.symmetric(horizontal: 8), // Increased margin
                      decoration: BoxDecoration(
                        color: selectedCategory == category ? Colors.blue : Colors.grey[300],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          color: selectedCategory == category ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // NEWS LIST
          Expanded(
            child: newsList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final article = newsList[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Better spacing
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          title: Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(article.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                          leading: article.imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(article.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
                                )
                              : Container(width: 80, height: 80, color: Colors.grey[300]),
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
                    },
                  ),
          ),
        ],
      ),

      // NAVBAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
        ],
      ),
    );
  }
}
