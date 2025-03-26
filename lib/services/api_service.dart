import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

class ApiService {
  final String apiKey = 'Replace_With_Your_Own_API_Key'; 
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<NewsArticle>> fetchNews({String category = 'general'}) async {
    final url = Uri.parse('$baseUrl?country=us&category=$category&apiKey=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> articles = data['articles'];

      return articles.map((json) => NewsArticle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
