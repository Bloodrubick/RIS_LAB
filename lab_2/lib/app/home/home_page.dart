import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mad_flutter_practicum/app/currency_list/currency_list_page.dart';
import 'package:mad_flutter_practicum/app/home/cubit/home_cubit.dart';
import 'package:mad_flutter_practicum/app/home/cubit/home_state.dart';
import 'package:mad_flutter_practicum/app/news_list/news_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  static const List<Widget> _pages = <Widget>[
    CurrencyListPage(),
    NewsListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.tabIndex,
            children: _pages,
          ),
          bottomNavigationBar: DecoratedBox(
             decoration: const BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 25,
                  offset: Offset(0.0, 0.75),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: state.tabIndex,
              onTap: (index) => context.read<HomeCubit>().setTabIndex(index),
              items: [
                BottomNavigationBarItem(
                  icon: TabWidget(
                    assetPath: 'assets/icons/home.png', // Assuming icon names
                    isSelected: state.tabIndex == 0,
                  ),
                  label: 'Курс Валют',
                ),
                BottomNavigationBarItem(
                  icon: TabWidget(
                    assetPath: 'assets/icons/news.png', // Assuming icon names
                    isSelected: state.tabIndex == 1,
                  ),
                  label: 'Новости',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({
    super.key,
    required this.assetPath,
    required this.isSelected,
  });

  final String assetPath;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBarThemeData bottomBarTheme = Theme.of(context).bottomNavigationBarTheme;

    return SizedBox.square(
      dimension: 24,
      child: Image.asset(
        assetPath,
        color: isSelected ? bottomBarTheme.selectedItemColor : bottomBarTheme.unselectedItemColor,
      ),
    );
  }
}
