import 'app_localizations.dart';

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get login => 'Einloggen';

  @override
  String get logout => 'Ausloggen';

  @override
  String get currencyRate => 'Wechselkurse';

  @override
  String get news => 'Nachrichten';

  @override
  String get profile => 'Profil';

  @override
  String get theme => 'Thema';

  @override
  String get light => 'Hell';

  @override
  String get dark => 'Dunkel';

  @override
  String get system => 'System';

  @override
  String get search => 'Suche';

  @override
  String asNominal(int value) {
    return '($value Stk.)';
  }

  @override
  String get clearCache => 'Cache leeren';

  @override
  String get lastUpdate => 'Letztes Update';

  @override
  String get cacheCleared => 'Cache geleert';

  @override
  String get noData => 'Keine Daten';

  @override
  String get noInternetNoData => 'Kein Internet und keine lokalen Daten';

  @override
  String get retry => 'Wiederholen';

  @override
  String error(String error) {
    return 'Fehler: $error';
  }

  @override
  String get noNews => 'Keine Nachrichten';

  @override
  String get language => 'Sprache';
}
