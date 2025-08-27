import 'dart:convert';

import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/news_channel_headline_model.dart';
import 'package:http/http.dart' as http;

class NewsRespository {
  Future<NewsChannelsHeadlineModel> fetchNewsChannelHeadlinesApi(
    String channelname,
  ) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=$channelname&apiKey=bc419f524a544fc0a06f8b26045a5db3";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return NewsChannelsHeadlineModel.fromJson(body);
    }
    throw Exception('Error');
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=$category&apiKey=bc419f524a544fc0a06f8b26045a5db3";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoriesNewsModel.fromJson(body);
    }
    throw Exception('Error');
  }
}
