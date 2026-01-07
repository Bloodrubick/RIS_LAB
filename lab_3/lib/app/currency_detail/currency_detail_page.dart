import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_detail/widgets/currency_info_card.dart';

class CurrencyDetailPage extends StatelessWidget {
  const CurrencyDetailPage({super.key, required this.title});

  final String title;

  static const double _defaultLeadingWidth = 56;
  static const double _titleSpacing = 24;

  @override
  Widget build(BuildContext context) {
    // Mock data for history with varied values and growth direction
    final List<Map<String, dynamic>> history = [
      {'date': 'Ср. 10:47 05.02.25', 'value': '61.50', 'isGrowth': true},
      {'date': 'Вт. 10:47 04.02.25', 'value': '60.99', 'isGrowth': false},
      {'date': 'Пн. 10:47 03.02.25', 'value': '61.20', 'isGrowth': true},
      {'date': 'Вс. 10:47 02.02.25', 'value': '60.80', 'isGrowth': false},
      {'date': 'Сб. 10:47 01.02.25', 'value': '60.99', 'isGrowth': true},
      {'date': 'Пт. 10:47 31.01.25', 'value': '60.50', 'isGrowth': true},
      {'date': 'Чт. 10:47 30.01.25', 'value': '59.90', 'isGrowth': false},
    ];

    return Scaffold(
      appBar: AppBar(
        leadingWidth: _defaultLeadingWidth + _titleSpacing,
        titleSpacing: _titleSpacing,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
        child: ListView.separated(
          itemCount: history.length,
          padding: const EdgeInsets.only(bottom: 40),
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final item = history[index];
            return CurrencyInfoCard(
              date: item['date'],
              value: item['value'],
              isGrowth: item['isGrowth'],
            );
          },
        ),
      ),
    );
  }
}
