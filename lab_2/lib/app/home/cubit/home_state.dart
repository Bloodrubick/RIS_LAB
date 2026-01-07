part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int selectedIndex;

  const HomeState({this.selectedIndex = 0});

  @override
  List<Object> get props => [selectedIndex];
}
