import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/currency_card.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/search_view.dart';
import 'package:mad_flutter_practicum/app/utils/context_ext.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:provider/provider.dart';

class CurrencyListPage extends StatefulWidget {
  const CurrencyListPage({super.key});

  @override
  State<CurrencyListPage> createState() => _CurrencyListPageState();
}

class _CurrencyListPageState extends State<CurrencyListPage> {
  late final ValueNotifier<List<CurrencyModel>> _filteredCurrencies;
  // Initialize with placeholder
  Future<List<CurrencyModel>> _currencyListFuture = Future.value([]);
  List<CurrencyModel> _allCurrencies = [];

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = ValueNotifier([]);
    _currencyListFuture = _initData();
  }

  @override
  void dispose() {
    _filteredCurrencies.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
      setState(() {
          _currencyListFuture = _initData();
      });
  }

  Future<List<CurrencyModel>> _initData() async {
    final currencyRepository = context.read<CurrencyRepository>();

    // Logic moved to Repository (Grade 4 Auto-switch)
    return currencyRepository.getCurrencyList().then((List<CurrencyModel> value) {
      if (mounted) {
        _allCurrencies = value;
        _filteredCurrencies.value = value;
      }
      return value;
    });
  }

  void _filterCurrencies(String query) {
    final String lowerQuery = query.toLowerCase();
    final Iterable<CurrencyModel> result = _allCurrencies.where((CurrencyModel currency) {
      return currency.name.toLowerCase().contains(lowerQuery) || currency.symbol.toLowerCase().contains(lowerQuery);
    });

    _filteredCurrencies.value = result.toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Курс Валют'),
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder(
          future: _currencyListFuture,
          builder: (BuildContext context, AsyncSnapshot<List<CurrencyModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Ошибка: ${snapshot.error}', style: context.fonts.regular14),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: const Text('Повторить попытку'),
                    ),
                  ],
                ),
              );
            }

            final List<CurrencyModel>? data = snapshot.data;
            if (data == null || data.isEmpty) {
              return Center(child: Text('Нет данных', style: context.fonts.regular14));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
                  child: SearchView(onChanged: _filterCurrencies),
                ),
                Expanded(
                  child: ValueListenableBuilder<List<CurrencyModel>>(
                    valueListenable: _filteredCurrencies,
                    builder: (BuildContext context, List<CurrencyModel> data, _) {
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final CurrencyModel currency = data[index];

                          return Padding(
                            key: ValueKey(currency.id),
                            padding: index == 0 ? const EdgeInsets.only(top: 20) : const EdgeInsets.only(top: 10),
                            child: CurrencyCard(model: currency),
                          );
                        },
                        padding: const EdgeInsets.fromLTRB(22, 0, 22, 40),
                      );
                    }
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
