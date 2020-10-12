part of 'city_bloc.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object> get props => [];
}

class CityInitial extends CityState {}

class CityFetching extends CityState {}

class CityLoadSuccess extends CityState {
  final List<City> cities;
  final List<Weather> weathers;

  const CityLoadSuccess({@required this.cities, @required this.weathers}) : assert(cities != null), assert(weathers != null);

  @override
  List<Object> get props => [cities, weathers];
}

class CityLoadFailure extends CityState {}

class CityStandby extends CityState {
  final List<City> cities;
  final List<Weather> weathers;

  const CityStandby({@required this.cities, @required this.weathers}) : assert(cities != null), assert(weathers != null);

  @override
  List<Object> get props => [cities, weathers];
}

class CitySubscriptionsSuccess extends CityState {
  final List<City> cities;
  final List<Weather> weathers;

  const CitySubscriptionsSuccess({@required this.cities, @required this.weathers}) : assert(weathers != null);

  @override
  List<Object> get props => [weathers];
}

class CityChangeTab extends CityState {
  final String route;

  CityChangeTab(this.route);

  @override
  // TODO: implement props
  List<Object> get props => [route];
}
