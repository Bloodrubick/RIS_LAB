import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/currency_card.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/search_view.dart';
import 'package:mad_flutter_practicum/domain/currency.dart';

class CurrencyListPage extends StatefulWidget {
  const CurrencyListPage({super.key});

  @override
  State<CurrencyListPage> createState() => _CurrencyListPageState();
}

class _CurrencyListPageState extends State<CurrencyListPage> {
  late List<Currency> _currencies;

  @override
  void initState() {
    super.initState();
    // Mock data with realistic codes
    final codes = ['AUD', 'USD', 'EUR', 'GBP', 'JPY', 'CAD', 'CHF', 'CNY', 'RUB', 'BRL'];
    final names = [
      'Австралийский доллар', 'Доллар США', 'Евро', 'Фунт стерлингов',
      'Японская иена', 'Канадский доллар', 'Швейцарский франк',
      'Китайский юань', 'Российский рубль', 'Бразильский реал'
    ];

    _currencies = List.generate(20, (index) {
      final code = codes[index % codes.length];
      final name = names[index % names.length];

      return Currency(
        title: '$name ${index > 9 ? (index + 1) : ""}', // Add suffix to distinguish duplicates
        code: code,
        subtitle: index % 3 == 0 ? 'Subtitle for $index' : '',
        amount: '${(60 + index * 0.5).toStringAsFixed(2)}',
        isFavorite: index % 2 == 0,
      );
    });
  }

  void _toggleFavorite(int index) {
    setState(() {
      _currencies[index].isFavorite = !_currencies[index].isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Курс Валют')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 500;

          return Padding(
            padding: const EdgeInsets.fromLTRB(22, 10, 22, 0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: SearchView(),
                ),
                Expanded(
                  child: isWide
                      ? GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent: 80,
                          ),
                          itemCount: _currencies.length,
                          itemBuilder: (context, index) {
                            final currency = _currencies[index];
                             return CurrencyCard(
                               title: currency.title,
                               code: currency.code,
                               subtitle: currency.subtitle,
                               amount: currency.amount,
                               isFavorite: currency.isFavorite,
                               onFavoriteTap: () => _toggleFavorite(index),
                             );
                          },
                        )
                      : ListView.separated(
                          itemCount: _currencies.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final currency = _currencies[index];
                            return CurrencyCard(
                               title: currency.title,
                               code: currency.code,
                               subtitle: currency.subtitle,
                               amount: currency.amount,
                               isFavorite: currency.isFavorite,
                               onFavoriteTap: () => _toggleFavorite(index),
                             );
                          },
                        ),
                ),
                // Add some bottom padding safely
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
