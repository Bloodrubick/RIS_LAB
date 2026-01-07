import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:provider/provider.dart';

class CurrencyDetailPage extends StatefulWidget {
  const CurrencyDetailPage({super.key, required this.currencyId, required this.title});

  final String currencyId;
  final String title;

  @override
  State<CurrencyDetailPage> createState() => _CurrencyDetailPageState();
}

class _CurrencyDetailPageState extends State<CurrencyDetailPage> {
  late Future<List<CurrencyRateModel>> _dynamicsFuture;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final monthAgo = now.subtract(const Duration(days: 30));
    _dynamicsFuture = context.read<CurrencyRepository>().getCurrencyDynamics(widget.currencyId, monthAgo, now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<CurrencyRateModel>>(
        future: _dynamicsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
             return Center(child: Text('Ошибка загрузки данных: ${snapshot.error}'));
          }

          final data = snapshot.data;
          if (data == null || data.isEmpty) {
            return const Center(child: Text('Нет данных за последний месяц'));
          }

          // Sort by date descending
          final sortedData = List<CurrencyRateModel>.from(data)..sort((a, b) => b.date.compareTo(a.date));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sortedData.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final item = sortedData[index];
              return ListTile(
                title: Text(DateFormat('dd.MM.yyyy').format(item.date)),
                trailing: Text(
                  item.value.toStringAsFixed(4),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
