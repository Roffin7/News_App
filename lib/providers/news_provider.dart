import 'package:flutter/material.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';

class NewsProvider with ChangeNotifier {
  List<NewsArticle> _newsList = [];
  bool _isLoading = false;

  List<NewsArticle> get newsList => _newsList;
  bool get isLoading => _isLoading;

  Future<void> getNews() async {
    _isLoading = true;
    notifyListeners();

    try {
      _newsList = await ApiService().fetchNews();
    } catch (e) {
      print("Error fetching news: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}
