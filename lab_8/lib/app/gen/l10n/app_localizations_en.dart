import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get currencyRate => 'Exchange Rate';

  @override
  String get news => 'News';

  @override
  String get profile => 'Profile';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get search => 'Search';

  @override
  String asNominal(int value) {
    return '($value pcs.)';
  }

  @override
  String get clearCache => 'Clear cache';

  @override
  String get lastUpdate => 'Last update date';

  @override
  String get cacheCleared => 'Cache cleared';

  @override
  String get noData => 'No data';

  @override
  String get noInternetNoData => 'No internet and no local data';

  @override
  String get retry => 'Retry';

  @override
  String error(String error) {
    return 'Error: $error';
  }

  @override
  String get noNews => 'No news';

  @override
  String get language => 'Language';
}
