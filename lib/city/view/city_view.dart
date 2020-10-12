import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weatherapp/city/bloc/city_bloc.dart';
import 'package:weatherapp/city/city.dart';
import 'package:weatherapp/login/login.dart';
import 'package:weatherapp/search/view/search_pager.dart';
import 'package:weatherapp/weather/view/view.dart';

import '../../NavDrawer.dart';

class CitiesView extends StatelessWidget {

  CitiesView({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CityBloc, CityState>(
      listener: (context, state) {
        print(state);
        if (state is CityInitial) {

        }
      },
      child: Scaffold(
        drawer: BlocBuilder<CityBloc, CityState>(
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
            return current is CityInitial;
          },
        ),
        appBar: AppBar(
          title: Text(title),
        ),
        body: _CityNotificationListener(),
      ),
    );
  }
}

class _CityNotificationListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityBloc, CityState>(
      builder: (context, state) {
        if (state is CityInitial) {
          context.bloc<CityBloc>().add(CityFetchEvent());
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return NotificationListener(
            onNotification: (ScrollNotification notification) {
              if (notification.metrics.pixels ==
                  notification.metrics.maxScrollExtent) {
                context.bloc<CityBloc>().add(const CityFetchEvent());
              }
              return true;
            },
            child: CityListView());
      },
    );
  }
}

class CityListView extends StatelessWidget {
  List<City> _cities = List();
  List<Weather> _weathers = List();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityBloc, CityState>(
      builder: (context, state) {
        if (state is CityLoadSuccess) {
          _cities = state.cities;
          _weathers = state.weathers;
        }
        if (state is CityStandby) {
          _cities = state.cities;
          _weathers = state.weathers;
        }

        return ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
            padding: const EdgeInsets.all(8),
            itemCount: _cities.length,
            itemBuilder: (BuildContext context, int index) {
              return CityTile(_cities[index], _weathers);
            });
      },
      buildWhen: (previous, current) {
        return current is CityLoadSuccess ||
            current is CityStandby;
      },
    );
  }
}

class CityTile extends StatelessWidget {
  final City _city;
  final List<Weather> _weathers;

  CityTile(this._city, this._weathers);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
          text: TextSpan(children: [
        WidgetSpan(
            child: Icon(
          Icons.location_city,
          color: Colors.grey,
        )),
        TextSpan(
          text: '  ',
        ),
        TextSpan(text: _city.name, style: TextStyle(color: Colors.black)),
        TextSpan(
            text: ', ' + _city.country, style: TextStyle(color: Colors.black)),
      ], style: TextStyle(fontSize: 18))),
      onTap: () {
        if (_weathers
            .where((element) => element.city.id == _city.id)
            .isNotEmpty) {
          context.bloc<CityBloc>().add(CityUnsubscribeEvent(_city.id));
        } else {
          context.bloc<CityBloc>().add(CitySubscribeEvent(_city.id));
        }
      },
      trailing: Visibility(
        visible: _weathers
            .where((element) => element.city.id == _city.id)
            .isNotEmpty,
        child: Icon(
          Icons.check,
          color: Colors.green,
        ),
      ),
    );
  }
}
