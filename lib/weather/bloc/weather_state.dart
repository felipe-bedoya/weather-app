part of 'weather_bloc.dart';

abstract class WeatherState extends Equatable{
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoadSuccess extends WeatherState {
  final List<Weather> weathers;

  WeatherLoadSuccess({@required this.weathers}): assert(weathers != null);

  @override
  List<Object> get props => [weathers];
}

class WeatherLoadFailure extends WeatherState {}