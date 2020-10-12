import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weatherapp/authentication/authentication.dart';
import 'package:weatherapp/login/view/login_page.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:weatherapp/splash/view/splash_page.dart';

import 'city/view/city_page.dart';

class App extends StatelessWidget {
  const App({
    Key key,
    @required this.authenticationRepository,
    @required this.userRepository,
    @required this.weatherRepository,
    @required this.cityRepository,
  })  : assert(authenticationRepository != null),
        assert(userRepository != null),
        assert(weatherRepository != null),
        assert(cityRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;
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
        RepositoryProvider.value(value: authenticationRepository),
      ],
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) async {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                // final userRepository = context.repository<UserRepository>();
                // await userRepository.fetchUser(state.user.token);
                _navigator.pushAndRemoveUntil<void>(
                  CityPage.route(
                    context.repository(),
                    context.repository(),
                    context.repository(),
                  ),
                  (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
