import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mad_flutter_practicum/domain/currency.dart';

class CbrService {
  static const String _url = 'https://www.cbr-xml-daily.ru/daily_json.js';

  Future<List<Currency>> fetchCurrencies() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final Map<String, dynamic> valute = json['Valute'];

      return valute.entries.map((e) {
        final Map<String, dynamic> data = e.value;
        final double current = (data['Value'] as num).toDouble();
        final double previous = (data['Previous'] as num).toDouble();

        return Currency(
          title: data['Name'] as String,
          code: data['CharCode'] as String,
          subtitle: '1 ${data['CharCode']} = $current RUB', // e.g. "1 USD = 92.5 RUB"
          amount: current.toStringAsFixed(2),
          isGrowth: current >= previous,
          isFavorite: false,
        );
      }).toList();
    } else {
      throw Exception('Failed to load currencies');
    }
  }
}
