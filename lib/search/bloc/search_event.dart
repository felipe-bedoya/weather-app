part of 'search_bloc.dart';

class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchFetchEvent extends SearchEvent {
  final String search;

  SearchFetchEvent(this.search);

  @override
  List<Object> get props => [search];
}

class SearchCancelEvent extends SearchEvent {
}

class SearchSubscribeEvent extends SearchEvent {
  final String cityId;

  SearchSubscribeEvent({this.cityId});

  @override
  List<Object> get props => [cityId];}

class SearchUnsubscribeEvent extends SearchEvent {
  final String cityId;

  SearchUnsubscribeEvent({this.cityId});

  @override
  List<Object> get props => [cityId];
}