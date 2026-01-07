import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';

abstract interface class RestDatasource {
  Future<List<CurrencyModel>> getCurrencyList();

  Future<List<NewsModel>> getNewsList();

  Future<List<CurrencyRateModel>> getCurrencyDynamics(String currencyId, DateTime startDate, DateTime endDate);
}
