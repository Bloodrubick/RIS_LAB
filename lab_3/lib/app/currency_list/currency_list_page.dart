import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mad_flutter_practicum/app/currency_list/cubit/currency_cubit.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/currency_card.dart';
import 'package:mad_flutter_practicum/app/currency_list/widgets/search_view.dart';
import 'package:mad_flutter_practicum/app/currency_detail/currency_detail_page.dart';
import 'package:mad_flutter_practicum/domain/currency.dart';

class CurrencyListPage extends StatelessWidget {
  const CurrencyListPage({super.key});

  void _onCardTap(BuildContext context, Currency currency) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CurrencyDetailPage(title: currency.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Курс Валют')),
      body: BlocBuilder<CurrencyCubit, CurrencyState>(
        builder: (context, state) {
          if (state is CurrencyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CurrencyError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is CurrencyLoaded) {
            final currencies = state.currencies;

            return LayoutBuilder(
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
                                itemCount: currencies.length,
                                itemBuilder: (context, index) {
                                  final currency = currencies[index];
                                  return CurrencyCard(
                                    title: currency.title,
                                    code: currency.code,
                                    subtitle: currency.subtitle,
                                    amount: currency.amount,
                                    isFavorite: currency.isFavorite,
                                    isGrowth: currency.isGrowth,
                                    onFavoriteTap: () => context.read<CurrencyCubit>().toggleFavorite(index),
                                    onTap: () => _onCardTap(context, currency),
                                  );
                                },
                              )
                            : ListView.separated(
                                itemCount: currencies.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final currency = currencies[index];
                                  return CurrencyCard(
                                    title: currency.title,
                                    code: currency.code,
                                    subtitle: currency.subtitle,
                                    amount: currency.amount,
                                    isFavorite: currency.isFavorite,
                                    isGrowth: currency.isGrowth,
                                    onFavoriteTap: () => context.read<CurrencyCubit>().toggleFavorite(index),
                                    onTap: () => _onCardTap(context, currency),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
