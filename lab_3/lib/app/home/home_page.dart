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

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  Future<void> _onTap(int index, BuildContext context) async {
    final cubit = context.read<HomeCubit>();
    if (cubit.state.tabIndex == index) {
      // Pop to root if already selected
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      cubit.setTabIndex(index);
    }
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          const CurrencyListPage(),
          const NewsListPage(),
        ][index];
      },
    };
  }

  Widget _buildOffstageNavigator(int index, int selectedIndex) {
    return Offstage(
      offstage: selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => _routeBuilders(context, index)[routeSettings.name == '/' ? '/' : routeSettings.name]!(context),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              _buildOffstageNavigator(0, state.tabIndex),
              _buildOffstageNavigator(1, state.tabIndex),
            ],
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
              onTap: (index) => _onTap(index, context),
              items: [
                BottomNavigationBarItem(
                  icon: TabWidget(
                    assetPath: 'assets/icons/home.png',
                    isSelected: state.tabIndex == 0,
                  ),
                  label: 'Курс Валют',
                ),
                BottomNavigationBarItem(
                  icon: TabWidget(
                    assetPath: 'assets/icons/news.png',
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
