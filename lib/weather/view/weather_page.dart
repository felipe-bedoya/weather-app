import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weatherapp/city/city.dart';
import 'package:weatherapp/login/login.dart';
import 'package:weatherapp/search/view/view.dart';
import 'package:weatherapp/weather/bloc/weather_bloc.dart';

import '../../NavDrawer.dart';
import 'weather_view.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({
    Key key,
    @required this.userRepository,
    @required this.weatherRepository,
  })  : assert(userRepository != null),
        assert(weatherRepository != null),
        super(key: key);

  static Route route(
      UserRepository userRepository, WeatherRepository weatherRepository) {
    return MaterialPageRoute<void>(
        builder: (_) => WeatherPage(
              userRepository: userRepository,
              weatherRepository: weatherRepository,
            ));
  }

  final UserRepository userRepository;
  final WeatherRepository weatherRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: userRepository),
          RepositoryProvider.value(value: weatherRepository),
        ],
        child: BlocProvider(
          create: (_) => WeatherBloc(
            weatherRepository: weatherRepository,
            userRepository: userRepository,
          ),
          child: WeatherView(),
        ));
  }
}

class WeatherView extends StatefulWidget {
  @override
  _WeatherViewState createState() => _WeatherViewState();
}

class _WeatherViewState extends State<WeatherView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('The Weather App'),
          ),
          drawer: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              return NavDrawer(toCities: () {
                Navigator.of(context).pushAndRemoveUntil(
                    CityPage.route(context.repository(), context.repository(),
                        context.repository()),
                    (route) => false);
              }, toSearch: () {
                Navigator.of(context).pushAndRemoveUntil(
                    SearchPage.route(context.repository(), context.repository(),
                        context.repository()),
                    (route) => false);
              }, toWeather: () {
                Navigator.of(context).pushAndRemoveUntil(
                    WeatherPage.route(
                        context.repository(), context.repository()),
                    (route) => false);
              }, toLogin: () {
                Navigator.of(context)
                    .pushAndRemoveUntil(LoginPage.route(), (route) => false);
              });
            },
            buildWhen: (previous, current) {
              return current is WeatherInitial;
            },
          ),
          body: WeathersView(),
        ));
  }
}
