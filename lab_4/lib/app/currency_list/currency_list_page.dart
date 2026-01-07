import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/currency_card.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/search_view.dart';
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
  late Future<List<CurrencyModel>> _currencyListFuture;
  List<CurrencyModel> _allCurrencies = [];

  @override
  void initState() {
    super.initState();
    _filteredCurrencies = ValueNotifier([]);
    // Assign directly in initState without setState
    _currencyListFuture = _loadData();
  }

  @override
  void dispose() {
    _filteredCurrencies.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _currencyListFuture = _loadData();
    });
  }

  Future<List<CurrencyModel>> _loadData() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
       return Future.error('No Internet Connection');
    }

    // We can't check 'mounted' reliably before the first await in initState flow,
    // but context.read works if we are in a valid context.
    // However, in initState, context is valid but we can't await inside initState directly.
    // _loadData is async, so it returns a Future.

    // Note: context.read is safe in callbacks or listeners, but potentially risky if
    // widget is disposed quickly.

    try {
        return context.read<CurrencyRepository>().getCurrencyList().then((List<CurrencyModel> value) {
            // Need to check mounted before updating state variables like _filteredCurrencies
            if (mounted) {
              _allCurrencies = value;
              _filteredCurrencies.value = value;
            }
            return value;
        });
    } catch (e) {
        return Future.error(e);
    }
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

            final List<CurrencyModel>? data = snapshot.data;
            if (data == null || data.isEmpty) {
               return const Center(child: Text('Нет данных'));
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
