import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mad_flutter_practicum/domain/datasource/db_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  const CurrencyRepositoryImpl(this._restDatasource, this._dbDatasource);

  final RestDatasource _restDatasource;
  final DbDatasource _dbDatasource;

  @override
  Future<List<CurrencyModel>> getCurrencyList() async {
      // Grade 4: Auto-switch logic
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
          final dbData = await _dbDatasource.getCurrencyList();
          if (dbData.isNotEmpty) return dbData;
          // If empty, we might throw or return empty, enabling UI to show "No Data / No Internet"
          throw Exception('Нет интернета и локальных данных');
      }

      try {
          final data = await _restDatasource.getCurrencyList();
          await _dbDatasource.saveCurrencyList(data);
          return data;
      } catch (e) {
          // If fetch fails, fallback to DB?
          final dbData = await _dbDatasource.getCurrencyList();
          if (dbData.isNotEmpty) return dbData;
          rethrow;
      }
  }

  @override
  Future<List<CurrencyRateModel>> getCurrencyDynamics(String currencyId, DateTime startDate, DateTime endDate) {
      return _restDatasource.getCurrencyDynamics(currencyId, startDate, endDate);
  }

  @override
  Future<void> saveCurrencyList(List<CurrencyModel> value) => _dbDatasource.saveCurrencyList(value);

  @override
  Future<void> clearCache() => _dbDatasource.clearCache();

  @override
  Future<DateTime?> getLastUpdated() => _dbDatasource.getLastUpdated();
}
