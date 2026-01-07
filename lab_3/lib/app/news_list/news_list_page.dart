import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/news_list/widgets/news_card.dart';
import 'package:mad_flutter_practicum/app/playground/playground_page.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate 20 varied news items
    final List<Map<String, String>> news = List.generate(20, (index) {
      final titles = [
        'Вводятся новые правила допуска на финансовый рынок кредитных потребительских кооперативов',
        'Банк России повысил ключевую ставку до 16%',
        'Инфляционные ожидания населения и предприятий в декабре 2023 года',
        'О развитии банковского сектора Российской Федерации в ноябре 2023 года',
        'Динамика потребительских цен: ноябрь 2023 года'
      ];
      final dates = [
        'Ср. 10:47 05.02.25',
        'Пт. 13:30 15.12.23',
        'Вт. 11:00 12.12.23',
        'Пн. 15:00 11.12.23',
        'Чт. 17:45 07.12.23'
      ];

      return {
        'title': '${titles[index % titles.length]} (${index + 1})',
        'date': dates[index % dates.length],
        'source': 'cbr.ru',
        'url': 'https://cbr.ru'
      };
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новости'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bug_report),
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => const PlaygroundPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;
                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ],
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
