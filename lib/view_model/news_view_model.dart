import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/news_channel_headline_model.dart';
import 'package:flutter_news_app/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRespository();
  Future<NewsChannelsHeadlineModel> fetchNewsChannelHeadlinesApi(
    String channelname,
  ) async {
    final response = await _rep.fetchNewsChannelHeadlinesApi(channelname);
    return response;
  }

  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}
