import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';
import 'app.dart';

void main() {
  runApp(App(
    authenticationRepository: AuthenticationRepository(),
    userRepository: UserRepository(),
    weatherRepository: WeatherRepository(),
    cityRepository: CityRepository(),
  ));
}
