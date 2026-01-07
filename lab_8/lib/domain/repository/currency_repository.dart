import 'package:mad_flutter_practicum/domain/model/currency_model.dart';

abstract interface class CurrencyRepository {
  Future<List<CurrencyModel>> getCurrencyList();
  Future<List<CurrencyRateModel>> getCurrencyDynamics(String currencyId, DateTime startDate, DateTime endDate);

  Future<void> saveCurrencyList(List<CurrencyModel> value);
  Future<void> clearCache();
  Future<DateTime?> getLastUpdated();
}

class CurrencyRateModel {
  const CurrencyRateModel({required this.date, required this.value});
  final DateTime date;
  final double value;
}
