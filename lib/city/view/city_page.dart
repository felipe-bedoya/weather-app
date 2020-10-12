import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weatherapp/city/bloc/city_bloc.dart';
import 'package:weatherapp/city/view/city_view.dart';

class CityPage extends StatelessWidget {
  const CityPage({
    Key key,
    @required this.userRepository,
    @required this.weatherRepository,
    @required this.cityRepository,
  })  : assert(userRepository != null),
        assert(weatherRepository != null),
        assert(cityRepository != null),
        super(key: key);

  static Route route(UserRepository userRepository,
      WeatherRepository weatherRepository, CityRepository cityRepository) {
    return MaterialPageRoute<void>(
        builder: (_) => CityPage(
              userRepository: userRepository,
              weatherRepository: weatherRepository,
              cityRepository: cityRepository,
            ));
  }

  final UserRepository userRepository;
  final WeatherRepository weatherRepository;
  final CityRepository cityRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: userRepository),
          RepositoryProvider.value(value: weatherRepository),
          RepositoryProvider.value(value: cityRepository),
        ],
        child: BlocProvider(
          create: (_) => CityBloc(
            weatherRepository: weatherRepository,
            cityRepository: cityRepository,
            userRepository: userRepository,
          ),
          child: CityView(),
        ));
  }
}

class CityView extends StatefulWidget {
  @override
  _CityViewState createState() => _CityViewState();
}

class _CityViewState extends State<CityView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CitiesView(title: 'The Weather App'),
    );
  }
}
