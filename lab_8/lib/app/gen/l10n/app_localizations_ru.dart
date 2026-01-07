import 'app_localizations.dart';

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get login => 'Войти';

  @override
  String get logout => 'Выйти';

  @override
  String get currencyRate => 'Курс Валют';

  @override
  String get news => 'Новости';

  @override
  String get profile => 'Профиль';

  @override
  String get theme => 'Тема';

  @override
  String get light => 'Светлая';

  @override
  String get dark => 'Тёмная';

  @override
  String get system => 'Системная';

  @override
  String get search => 'Поиск';

  @override
  String asNominal(int value) {
    return '($value шт.)';
  }

  @override
  String get clearCache => 'Очистить кэш';

  @override
  String get lastUpdate => 'Дата последнего обновления';

  @override
  String get cacheCleared => 'Кэш очищен';

  @override
  String get noData => 'Нет данных';

  @override
  String get noInternetNoData => 'Нет интернета и нет локальных данных';

  @override
  String get retry => 'Повторить попытку';

  @override
  String error(String error) {
    return 'Ошибка: $error';
  }

  @override
  String get noNews => 'Нет новостей';

  @override
  String get language => 'Язык';
}
