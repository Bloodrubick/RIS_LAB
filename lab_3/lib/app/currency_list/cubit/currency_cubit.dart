import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mad_flutter_practicum/domain/currency.dart';
import 'package:mad_flutter_practicum/domain/repository/currency_repository.dart';

part 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  final CurrencyRepository _repository;

  CurrencyCubit(this._repository) : super(CurrencyInitial()) {
    loadCurrencies();
  }

  Future<void> loadCurrencies() async {
    try {
      emit(CurrencyLoading());
      final currencies = await _repository.getCurrencies();
      emit(CurrencyLoaded(currencies));
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }

  void toggleFavorite(int index) {
    if (state is CurrencyLoaded) {
      final currentState = state as CurrencyLoaded;
      final updatedCurrencies = List<Currency>.from(currentState.currencies);

      // Update the specific item
      final item = updatedCurrencies[index];
      item.isFavorite = !item.isFavorite; // Note: Currency is mutable for now, or copyWith

      // Ideally use copyWith but simple mutation works for list reference update
      emit(CurrencyLoaded(updatedCurrencies));
    }
  }
}
