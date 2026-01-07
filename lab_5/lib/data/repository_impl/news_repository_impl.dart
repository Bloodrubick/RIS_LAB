import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mad_flutter_practicum/domain/datasource/db_datasource.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(this._restDatasource, this._dbDatasource);

  final RestDatasource _restDatasource;
  final DbDatasource _dbDatasource;

  @override
  Future<List<NewsModel>> getNewsList() async {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
          final dbData = await _dbDatasource.getNewsList();
          if (dbData.isNotEmpty) return dbData;
          throw Exception('Нет интернета и локальных данных');
      }

      try {
          final data = await _restDatasource.getNewsList();
          await _dbDatasource.saveNewsList(data);
          return data;
      } catch (e) {
          final dbData = await _dbDatasource.getNewsList();
          if (dbData.isNotEmpty) return dbData;
          rethrow;
      }
  }

  @override
  Future<void> saveNewsList(List<NewsModel> value) => _dbDatasource.saveNewsList(value);

  @override
  Future<void> clearCache() => _dbDatasource.clearCache();

  @override
  Future<DateTime?> getLastUpdated() => _dbDatasource.getLastUpdated();
}
