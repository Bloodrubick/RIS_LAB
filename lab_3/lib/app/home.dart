import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mad_flutter_practicum/app/currency_list/currency_list_page.dart';
import 'package:mad_flutter_practicum/app/news_list/news_list_page.dart';
import 'package:mad_flutter_practicum/data/repository/currency_repository_impl.dart';
import 'package:mad_flutter_practicum/app/currency_list/cubit/currency_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Inject Repository and Cubit high enough so it persists across tab switches if needed,
    // or just inside the first tab. Here we wrap the whole Home with RepositoryProvider
    // but the Cubit can be scoped to the first tab or global.
    // Scoping to first tab is cleaner if only used there.

    return RepositoryProvider(
      create: (context) => CurrencyRepositoryImpl(),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildOffstageNavigator(0, const CurrencyListWrapper()), // Wrapped with BlocProvider
            _buildOffstageNavigator(1, const NewsListPage()),
          ],
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
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: TabWidget(
                  assetPath: 'assets/icons/home.png',
                  isSelected: _selectedIndex == 0,
                ),
                label: 'Курс Валют',
              ),
              BottomNavigationBarItem(
                icon: TabWidget(
                  assetPath: 'assets/icons/news.png',
                  isSelected: _selectedIndex == 1,
                ),
                label: 'Новости',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(int index, Widget rootPage) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => rootPage,
        );
      },
    );
  }
}

class CurrencyListWrapper extends StatelessWidget {
  const CurrencyListWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CurrencyCubit(context.read<CurrencyRepositoryImpl>()),
      child: const CurrencyListPage(),
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
