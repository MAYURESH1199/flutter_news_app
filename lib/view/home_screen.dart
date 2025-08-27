import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/models/categories_news_model.dart';
import 'package:flutter_news_app/models/news_channel_headline_model.dart';
import 'package:flutter_news_app/view/categories_screen.dart';
import 'package:flutter_news_app/view_model/news_view_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum NewsFilterList {
  bbcnews,
  associatedPress,
  abcNews,
  nbcNews,
  cnbc,
  cnn,
  hollywoodReporter,
}

class _HomeScreenState extends State<HomeScreen> {
  NewsFilterList? selectedMenu;
  NewsViewModel newsViewModel = NewsViewModel();
  final format = DateFormat('MMMM dd, yyyy');
  String channelname = 'bbc-news';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<NewsFilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (NewsFilterList item) {
              if (NewsFilterList.bbcnews.name == item.name) {
                channelname = 'bbc-news';
              }
              if (NewsFilterList.associatedPress.name == item.name) {
                channelname = 'associated-press';
              }
              // Add other conditions for other channels here
              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<NewsFilterList>>[
                  PopupMenuItem<NewsFilterList>(
                    value: NewsFilterList.bbcnews,
                    child: Text('BBC News'),
                  ),
                  PopupMenuItem<NewsFilterList>(
                    value: NewsFilterList.associatedPress,
                    child: Text('Associated Press'),
                  ),
                ],
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesScreen()),
            );
          },
          icon: Image.asset('images/category_icon.png', height: 30, width: 30),
        ),
        centerTitle: true,
        title: Text(
          'News',
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlineModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi('bbc-news'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(size: 50, color: Colors.blue),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      DateTime dateTime = DateTime.parse(
                        snapshot.data!.articles![index].publishedAt.toString(),
                      );
                      return SizedBox(
                        child: Stack(
                          children: [
                            Container(
                              width: width * .9,
                              height: height * .6,
                              padding: EdgeInsets.symmetric(
                                horizontal: height * .02,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot
                                      .data!
                                      .articles![index]
                                      .urlToImage
                                      .toString(),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(child: spinKit2),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              left: 20,
                              right: 20,
                              child: Card(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  alignment: Alignment.bottomLeft,
                                  padding: EdgeInsets.only(left: 10),
                                  height: height * .15,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: width * .9,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 5,
                                        ),
                                        child: Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot
                                                  .data!
                                                  .articles![index]
                                                  .source!
                                                  .name
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
              future: newsViewModel.fetchCategoriesNewsApi('general'),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(size: 50, color: Colors.blue),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('An error occurred: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data!.articles!.isEmpty) {
                  return Center(
                    child: Text('No news found for this category.'),
                  );
                } else {
                  // Changed scrollDirection to vertical for row-wise display
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.articles!.length,
                    // The default scrollDirection is vertical, so no need to explicitly set it
                    itemBuilder: (context, index) {
                      final article = snapshot.data!.articles![index];
                      DateTime dateTime = DateTime.parse(
                        article.publishedAt.toString(),
                      );
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: article.urlToImage.toString(),
                                fit: BoxFit.cover,
                                height: height * .18,
                                width: width * .3,
                                placeholder: (context, url) => Container(
                                  child: SpinKitCircle(
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.source!.name.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    article.title.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    format.format(dateTime),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

const spinKit2 = SpinKitFadingCircle(color: Colors.amber, size: 50);
