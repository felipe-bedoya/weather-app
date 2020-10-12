import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(
      {@required UserRepository userRepository,
        @required CityRepository cityRepository,
        @required WeatherRepository weatherRepository})
      : assert(userRepository != null),
        assert(cityRepository != null),
        assert(weatherRepository != null),
        _userRepository = userRepository,
        _cityRepository = cityRepository,
        _weatherRepository = weatherRepository,
        super(SearchInitial());

  final UserRepository _userRepository;
  final CityRepository _cityRepository;
  final WeatherRepository _weatherRepository;

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchFetchEvent) {
      yield* _mapFetchCitiesToState(event, state);
    } else if (event is SearchSubscribeEvent) {
      yield* _mapSubscribeToState(event, state);
    } else if (event is SearchUnsubscribeEvent) {
      yield* _mapUnsubscribeToState(event, state);
    } else if (event is SearchCancelEvent) {
      yield* _mapCancelToState(event, state);
    } else
      yield state;
  }

  Stream<SearchState> _mapFetchCitiesToState(
      SearchFetchEvent event,
      SearchState state,
      ) async* {
    final user = await _userRepository.getUser();
    final cities = await _cityRepository.search(event.search, user.token);
    final weathers = await _weatherRepository.subscriptions(user.token);
    yield SearchLoadSuccess(cities: cities, weather: weathers);
  }

  Stream<SearchState> _mapSubscribeToState(
      SearchSubscribeEvent event,
      SearchState state,
      ) async* {
    final user = await _userRepository.getUser();
    await _weatherRepository.subscribe(event.cityId, user.id, user.token);
    await _weatherRepository.subscriptions(user.token);
    final cities = await this._cityRepository.search(this._cityRepository.lastSearch, user.token);
    yield SearchLoadSuccess(
        cities: cities,
        weather: _weatherRepository.weathers);
  }

  Stream<SearchState> _mapUnsubscribeToState(
      SearchUnsubscribeEvent event,
      SearchState state,
      ) async* {
    final user = await _userRepository.getUser();
    await _weatherRepository.unsubscribe(event.cityId, user.id, user.token);
    await _weatherRepository.subscriptions(user.token);
    final cities = await this._cityRepository.search(this._cityRepository.lastSearch, user.token);
    yield SearchLoadSuccess(
        cities: cities,
        weather: _weatherRepository.weathers);
  }

  Stream<SearchState> _mapCancelToState(SearchCancelEvent event, SearchState state) {

  }

}