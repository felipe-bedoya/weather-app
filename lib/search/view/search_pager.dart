import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weatherapp/city/city.dart';
import 'package:weatherapp/login/login.dart';
import 'package:weatherapp/search/search.dart';
import 'package:weatherapp/weather/view/view.dart';

import '../../NavDrawer.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    Key key,
    @required this.userRepository,
    @required this.cityRepository,
    @required this.weatherRepository,
  })  : assert(userRepository != null),
        assert(weatherRepository != null),
        assert(cityRepository != null),
        super(key: key);

  static Route route(UserRepository userRepository,
      WeatherRepository weatherRepository, CityRepository cityRepository) {
    return MaterialPageRoute<void>(
        builder: (_) => SearchPage(
              cityRepository: cityRepository,
              userRepository: userRepository,
              weatherRepository: weatherRepository,
            ));
  }

  final CityRepository cityRepository;
  final UserRepository userRepository;
  final WeatherRepository weatherRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: userRepository),
          RepositoryProvider.value(value: weatherRepository),
        ],
        child: BlocProvider.value(
          value: SearchBloc(
            cityRepository: cityRepository,
            weatherRepository: weatherRepository,
            userRepository: userRepository,
          ),
          child: SearchView(),
        ));
  }
}

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Search App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: Text('The Search App'),
          ),
          drawer: BlocBuilder<SearchBloc, SearchState>(
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
              return current != previous;
            },
          ),
          body: SearchsView(),
        ));
  }
}
