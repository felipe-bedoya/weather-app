part of 'city_bloc.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object> get props => [];
}

class CityFetchEvent extends CityEvent {
  const CityFetchEvent();
}

class CitySubscribeEvent extends CityEvent {
  CitySubscribeEvent(this.cityId);

  final String cityId;

  List<Object> get props => [cityId];
}

class CityUnsubscribeEvent extends CityEvent {
  CityUnsubscribeEvent(this.cityId);

  final String cityId;

  List<Object> get props => [cityId];
}

class CityChangeTabEvent extends CityEvent {
  final String route;

  CityChangeTabEvent(this.route);

  @override
  List<Object> get props => [route];
}
