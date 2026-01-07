import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/news_list/widgets/news_card.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> news = [
      {
        'title': 'Вводятся новые правила допуска на финансовый рынок кредитных потребительских кооперативов',
        'date': 'Ср. 10:47 05.02.25',
        'source': 'cbr.ru',
        'url': 'https://cbr.ru'
      },
      {
        'title': 'Банк России повысил ключевую ставку до 16%',
        'date': 'Пт. 13:30 15.12.23',
        'source': 'cbr.ru',
        'url': 'https://cbr.ru'
      },
      {
        'title': 'Инфляционные ожидания населения и предприятий в декабре 2023 года',
        'date': 'Вт. 11:00 12.12.23',
        'source': 'cbr.ru',
        'url': 'https://cbr.ru'
      },
      {
        'title': 'О развитии банковского сектора Российской Федерации в ноябре 2023 года',
        'date': 'Пн. 15:00 11.12.23',
        'source': 'cbr.ru',
        'url': 'https://cbr.ru'
      },
      {
        'title': 'Динамика потребительских цен: ноябрь 2023 года',
        'date': 'Чт. 17:45 07.12.23',
        'source': 'cbr.ru',
        'url': 'https://cbr.ru'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новости'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
        child: ListView.separated(
          itemCount: news.length,
          padding: const EdgeInsets.only(bottom: 40),
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = news[index];
            return NewsCard(
              title: item['title']!,
              date: item['date']!,
              source: item['source']!,
              url: item['url']!,
            );
          },
        ),
      ),
    );
  }
}
