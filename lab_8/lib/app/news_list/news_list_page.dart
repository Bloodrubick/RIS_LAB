import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/news_list/widgets/news_card.dart';
import 'package:mad_flutter_practicum/app/utils/context_ext.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:provider/provider.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  // Initialize with empty future
  Future<List<NewsModel>> _newsListFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _newsListFuture = _initData();
  }

  Future<void> _refresh() async {
    setState(() {
      _newsListFuture = _initData();
    });
  }

  Future<List<NewsModel>> _initData() async {
    final newsRepository = context.read<NewsRepository>();
    return newsRepository.getNewsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.news),
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<NewsModel>>(
          future: _newsListFuture,
          builder: (BuildContext context, AsyncSnapshot<List<NewsModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              String errorText = context.loc.error(snapshot.error.toString());
              if (snapshot.error.toString().contains('Нет интернета и локальных данных') ||
                  snapshot.error.toString().contains('No Internet Connection')) {
                  errorText = context.loc.noInternetNoData;
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(errorText, style: context.fonts.regular14, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: Text(context.loc.retry),
                    ),
                  ],
                ),
              );
            }

            final List<NewsModel>? data = snapshot.data;
            if (data == null || data.isEmpty) {
               return Center(child: Text(context.loc.noNews, style: context.fonts.regular14));
            }

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final NewsModel news = data[index];

                return Padding(
                  key: ValueKey(news.link),
                  padding: index == 0 ? EdgeInsets.zero : const EdgeInsets.only(top: 16),
                  child: NewsCard(model: news),
                );
              },
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 40),
            );
          },
        ),
      ),
    );
  }
}
