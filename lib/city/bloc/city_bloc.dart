import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';

part 'city_event.dart';

part 'city_state.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  CityBloc(
      {@required UserRepository userRepository,
      @required CityRepository cityRepository,
      @required WeatherRepository weatherRepository})
      : assert(userRepository != null),
        assert(cityRepository != null),
        assert(weatherRepository != null),
        _userRepository = userRepository,
        _cityRepository = cityRepository,
        _weatherRepository = weatherRepository,
        super(CityInitial());

  final UserRepository _userRepository;
  final CityRepository _cityRepository;
  final WeatherRepository _weatherRepository;

  @override
  Stream<CityState> mapEventToState(CityEvent event) async* {
    if (event is CityFetchEvent) {
      yield* _mapFetchCitiesToState(event, state);
    } else if (event is CitySubscribeEvent) {
      yield* _mapSubscribeToState(event, state);
    } else if (event is CityUnsubscribeEvent) {
      yield* _mapUnsubscribeToState(event, state);
    } else if (event is CityChangeTabEvent) {
      yield* _mapChangeTabToState(event, state);
    } else
      yield state;
  }

  Stream<CityState> _mapFetchCitiesToState(
    CityFetchEvent event,
    CityState state,
  ) async* {
    final user = await _userRepository.getUser();
    final cities = await _cityRepository.fetchCities(user.token);
    final weathers = await _weatherRepository.subscriptions(user.token);
    yield CityLoadSuccess(cities: cities, weathers: weathers);
  }

  Stream<CityState> _mapSubscribeToState(
    CitySubscribeEvent event,
    CityState state,
  ) async* {
    final user = await _userRepository.getUser();
    await _weatherRepository.subscribe(event.cityId, user.id, user.token);
    await _weatherRepository.subscriptions(user.token);
    yield CityStandby(
        cities: this._cityRepository.cities,
        weathers: _weatherRepository.weathers);
  }

  Stream<CityState> _mapUnsubscribeToState(
    CityUnsubscribeEvent event,
    CityState state,
  ) async* {
    final user = await _userRepository.getUser();
    await _weatherRepository.unsubscribe(event.cityId, user.id, user.token);
    await _weatherRepository.subscriptions(user.token);
    yield CityStandby(
        cities: this._cityRepository.cities,
        weathers: _weatherRepository.weathers);
  }

  Stream<CityState> _mapChangeTabToState(
      CityChangeTabEvent event, CityState state) async* {
    yield CityChangeTab(event.route);
  }
}
