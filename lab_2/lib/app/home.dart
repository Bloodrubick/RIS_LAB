import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mad_flutter_practicum/app/currency_tab_container/currency_tab_container.dart';
import 'package:mad_flutter_practicum/app/home/cubit/home_cubit.dart';

import 'news_list/news_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const List<Widget> _pages = <Widget>[
    CurrencyTabContainer(),
    NewsListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final Widget currentPage = _pages[state.selectedIndex];

          return Scaffold(
            body: IndexedStack(
              index: state.selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: Container(
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
                currentIndex: state.selectedIndex,
                onTap: (index) => context.read<HomeCubit>().setTab(index),
                items: [
                  BottomNavigationBarItem(
                    icon: TabWidget(
                      assetPath: 'assets/icons/home.png',
                      isSelected: state.selectedIndex == 0,
                    ),
                    label: 'Курс Валют',
                  ),
                  BottomNavigationBarItem(
                    icon: TabWidget(
                      assetPath: 'assets/icons/news.png',
                      isSelected: state.selectedIndex == 1,
                    ),
                    label: 'Новости',
                  ),
                ],
              ),
            ),
          );
        },
      ),
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
