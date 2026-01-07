import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/app_http_client.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/mapper/currency_mapper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/mapper/news_mapper.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/model/currency_dto.dart';
import 'package:mad_flutter_practicum/data/datasource_impl/rest_datasource_impl/rest_path.dart';
import 'package:mad_flutter_practicum/domain/datasource/rest_datasource.dart';
import 'package:mad_flutter_practicum/domain/model/currency_model.dart';
import 'package:mad_flutter_practicum/domain/model/news_model.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:xml/xml.dart';

class RestDatasourceImpl implements RestDatasource {
  late final AppHttpClient _httpClient = AppHttpClient();

  @override
  Future<List<CurrencyModel>> getCurrencyList() async {
    final String? response = await _httpClient.getDecodedResponse(RestPath.dailyExchangeRateUrl);
    if (response == null) throw Exception('Failed to load currency list');

    final Map<String, dynamic> json = jsonDecode(response);

    return CurrencyListResponseDto.fromJson(json).valute.values.map((e) => e.model).toList(growable: false);
  }

  @override
  Future<List<NewsModel>> getNewsList() async {
    final String? response = await _httpClient.getDecodedResponse(RestPath.newsUrl);
    if (response == null) throw Exception('Failed to load news list');

    return RssFeed.parse(response).items.map((e) => e.asNewsModel).toList(growable: false);
  }

  @override
  Future<List<CurrencyRateModel>> getCurrencyDynamics(String currencyId, DateTime startDate, DateTime endDate) async {
    final formatter = DateFormat('dd/MM/yyyy');
    final responseFormatter = DateFormat('dd.MM.yyyy');
    final String start = formatter.format(startDate);
    final String end = formatter.format(endDate);

    // We need to fetch currency ID from CBR which might be different from the one in daily json.
    // The daily json ID looks like "R01235".
    // The query param is VAL_NM_RQ=R01235

    final String url = '${RestPath.dynamicUrl}?date_req1=$start&date_req2=$end&VAL_NM_RQ=$currencyId';
    final String? response = await _httpClient.getDecodedResponse(url);
    if (response == null) throw Exception('Failed to load currency dynamics');

    final document = XmlDocument.parse(response);
    final records = document.findAllElements('Record');

    final List<CurrencyRateModel> rates = [];

    for (var record in records) {
      final dateStr = record.getAttribute('Date');
      final valueStr = record.findElements('Value').single.innerText.replaceAll(',', '.');
      final nominalStr = record.findElements('Nominal').single.innerText;

      if (dateStr != null) {
        final date = responseFormatter.parse(dateStr);
        final value = double.tryParse(valueStr) ?? 0.0;
        final nominal = int.tryParse(nominalStr) ?? 1;

        rates.add(CurrencyRateModel(date: date, value: value / nominal));
      }
    }

    return rates;
  }
}
