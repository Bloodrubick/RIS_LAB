import 'package:mad_flutter_practicum/data/api/cbr_service.dart';
import 'package:mad_flutter_practicum/domain/currency.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CbrService _service;

  CurrencyRepositoryImpl({CbrService? service}) : _service = service ?? CbrService();

  @override
  Future<List<Currency>> getCurrencies() async {
    return await _service.fetchCurrencies();
  }
}
