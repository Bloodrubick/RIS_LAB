import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/news_list/widgets/news_card.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:provider/provider.dart';

class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  late Future<List<NewsModel>> _newsListFuture;

  @override
  void initState() {
    super.initState();
    // Initialize directly, no setState
    _newsListFuture = _loadData();
  }

  Future<void> _refresh() async {
    setState(() {
      _newsListFuture = _loadData();
    });
  }

  Future<List<NewsModel>> _loadData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
       return Future.error('No Internet Connection');
    }

    // We can't check 'mounted' reliably before any await.
    // context.read is safe here usually.
    return context.read<NewsRepository>().getNewsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новости'),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Ошибка: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: const Text('Повторить попытку'),
                    ),
                  ],
                ),
              );
            }

            final List<NewsModel>? data = snapshot.data;
            if (data == null || data.isEmpty) {
              return const Center(child: Text('Нет новостей'));
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
