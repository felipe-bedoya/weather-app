part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoadSuccess extends SearchState {
  final List<City> cities;
  final List<Weather> weather;

  SearchLoadSuccess({this.cities, this.weather});

  @override
  List<Object> get props => [cities, weather];
}

class SearchLoadFailure extends SearchState {}
