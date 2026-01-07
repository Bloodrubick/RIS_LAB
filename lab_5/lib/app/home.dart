import 'package:flutter/material.dart';
import 'package:mad_flutter_practicum/app/currency_list/currency_list_page.dart';
import 'package:mad_flutter_practicum/app/news_list/news_list_page.dart';
import 'package:mad_flutter_practicum/app/profile/profile_page.dart';
import 'package:mad_flutter_practicum/app/utils/context_ext.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    CurrencyListPage(),
    NewsListPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // IndexedStack preserves state
    final Widget currentPage = IndexedStack(
       index: _selectedIndex,
       children: _pages,
    );

    final colors = context.colors;

    return Scaffold(
      body: currentPage,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colors.bottomNavBarShadow,
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
             BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Профиль',
            )
          ],
        ),
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
    // We can't access BottomNavigationBarThemeData directly easily for custom colors if we use custom theme extension approach strictly,
    // but Theme.of(context).bottomNavigationBarTheme should still be populated by our ThemeExt logic.
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
