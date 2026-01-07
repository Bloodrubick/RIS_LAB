import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mad_flutter_practicum/app/constants.dart';
import 'package:mad_flutter_practicum/app/home.dart';
import 'package:mad_flutter_practicum/app/login_page.dart';
import 'package:mad_flutter_practicum/app/splash_page.dart';
import 'package:mad_flutter_practicum/app/utils/theme/theme_data.dart';
import 'package:mad_flutter_practicum/app/utils/theme_mode_ext.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/preference_datasource_impl/preference_datasource_impl.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_datasource_impl.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/sqflite_datasource_impl/sqflite_datasource_impl.dart';
import 'package:mad_flutter_practicum/data/repository_impl/currency_repository_impl.dart';
import 'package:mad_flutter_practicum/data/repository_impl/news_repository_impl.dart';
import 'package:mad_flutter_practicum/data/repository_impl/settings_repository_impl.dart';
import 'package:mad_flutter_practicum/domain/datasource/db_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/preference_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/app_theme_mode.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';
import 'package:mad_flutter_practicum/domain/repository/settings_repository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting(AppConstants.ruLocale, null);

  final sharedPreferences = await SharedPreferences.getInstance();
  final secureStorage = FlutterSecureStorage();

  final restDatasource = RestDatasourceImpl();
  final dbDatasource = SqfliteDatasourceImpl();
  final preferenceDatasource = PreferenceDatasourceImpl(sharedPreferences, secureStorage);

  runApp(
    GlobalProviders(
      restDatasource: restDatasource,
      dbDatasource: dbDatasource,
      preferenceDatasource: preferenceDatasource,
      child: const App(),
    ),
  );
}

class GlobalProviders extends StatelessWidget {
  const GlobalProviders({
    super.key,
    required this.restDatasource,
    required this.dbDatasource,
    required this.preferenceDatasource,
    required this.child,
  });

  final RestDatasource restDatasource;
  final DbDatasource dbDatasource;
  final PreferenceDatasource preferenceDatasource;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CurrencyRepository>(
          create: (_) => CurrencyRepositoryImpl(
            restDatasource,
            dbDatasource,
          ),
        ),
        Provider<NewsRepository>(
          create: (_) => NewsRepositoryImpl(
            restDatasource,
            dbDatasource,
          ),
        ),
        Provider<SettingsRepository>(
          create: (_) => SettingsRepositoryImpl(preferenceDatasource),
        ),
      ],
      child: child,
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  // Accessing repo in initState or build needs care.
  // In build it's safe if Provider is above.

  // Actually, we can't access context.read inside initState easily if context isn't fully ready or if we need async init.
  // The structure below suggests initialization in initState.

  late final SettingsRepository _settingsRepository;

  @override
  void initState() {
    super.initState();
    // We can't access context here to get repository unless we do it in didChangeDependencies or build, or pass it.
    // However, App is child of GlobalProviders, so context should work in build.
    // But _initData is called in initState.
    // We will use addPostFrameCallback or Future.delayed to access context safely.

    WidgetsBinding.instance.addPostFrameCallback((_) {
         _settingsRepository = context.read<SettingsRepository>();
         _initData();
    });
  }

  Future<void> _initData() async {
    // This delay simulates splash screen delay or loading
    await Future.delayed(Duration(seconds: 1));
    await _settingsRepository.initAsyncData();
  }

  @override
  Widget build(BuildContext context) {
    // We need to wait for SettingsRepository to be available if we want to use it in StreamBuilder immediately
    // or handle the null case.
    // Since we are inside GlobalProviders, context.read works.

    // However, StreamBuilder needs the stream.
    // If _initData hasn't run, stream might be empty/null or controller not ready?
    // SettingsRepositoryImpl initializes controllers in constructor, so stream is valid.

    // We can just get repo here.
    final settingsRepo = context.read<SettingsRepository>();

    return StreamBuilder(
      stream: settingsRepo.themeModeStream,
      builder: (BuildContext context, AsyncSnapshot<AppThemeMode> snapshot) {
        final AppThemeMode appThemeMode = snapshot.data ?? settingsRepo.themeMode;

        return MaterialApp(
          theme: ThemeData.light().appThemeData,
          darkTheme: ThemeData.dark().appThemeData,
          themeMode: appThemeMode.themeMode,
          home: StreamBuilder(
            stream: settingsRepo.isAuthStream,
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) return const SplashPage();

              final bool isAuth = snapshot.data ?? false; // Default false until loaded? Or check repo.isAuth if initialized.

              // Note: SettingsRepository.isAuth is late bool. It might throw if accessed before init.
              // So we should rely on snapshot or check if initialized.
              // But initAsyncData is async.
              // While waiting, we show SplashPage (if connectionState is waiting).
              // However, the stream inside repo is a broadcast stream.

              // Let's rely on the stream having no data initially.
              // But if we return SplashPage on waiting, we are good.
              // We just need to make sure something eventually comes into the stream.
              // initAsyncData does add to stream.

              return isAuth ? const HomePage() : const LoginPage();
            },
          ),
        );
      },
    );
  }
}
