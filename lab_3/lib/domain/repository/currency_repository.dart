import 'package:mad_flutter_practicum/domain/currency.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> getCurrencies();
}
