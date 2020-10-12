import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(
      {@required UserRepository userRepository,
      @required WeatherRepository weatherRepository})
      : assert(userRepository != null),
        assert(weatherRepository != null),
        _userRepository = userRepository,
        _weatherRepository = weatherRepository,
        super(WeatherInitial());

  final UserRepository _userRepository;
  final WeatherRepository _weatherRepository;

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is WeatherFetchEvent) {
      yield* _mapFetchWeatherToState(event, state);
    } else {
      yield state;
    }
  }

  Stream<WeatherState> _mapFetchWeatherToState(
    WeatherFetchEvent event,
    WeatherState state,
  ) async* {
    final user = await _userRepository.getUser();
    final weathers = await _weatherRepository.subscriptions(user.token);
    yield WeatherLoadSuccess(weathers: weathers);
  }
}
