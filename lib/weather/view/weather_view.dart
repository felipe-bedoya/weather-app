import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_repository/weather_repository.dart';
import 'package:weatherapp/weather/bloc/weather_bloc.dart';

class WeathersView extends StatelessWidget {
  List<Weather> weathers;

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is WeatherInitial) {
            context.bloc<WeatherBloc>().add(WeatherFetchEvent());
          }
          Future.delayed(Duration(seconds: 10), () {
            context.bloc<WeatherBloc>().add(WeatherFetchEvent());
          });
        },
        child: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoadSuccess) {
              weathers = state.weathers;
            } else {
              weathers = List();
              context.bloc<WeatherBloc>().add(WeatherFetchEvent());
              return Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: Colors.grey,
                    ),
                padding: const EdgeInsets.all(8),
                itemCount: weathers.length,
                itemBuilder: (BuildContext context, int index) {
                  return WeatherCard(weather: weathers[index]);
                });
          },
          buildWhen: (previous, current) {
            return previous != current;
          },
        ));
  }
}

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Image.network(
                  'http://openweathermap.org/img/wn/' + weather.icon + '.png'),
              Text(
                weather.city.name,
                style: TextStyle(fontSize: 18),
              ),
              Spacer(),
              Text(
                weather.temperature.toString() + '°C',
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
          Row(
            children: [
              Text('\t\t\t'),
              Icon(Icons.opacity, size: 18),
              Text('Humidity: ' + weather.humidity.toString() + '%'),
            ],
          ),
          Row(
            children: [Text('')],
          ),
          Row(
            children: [
              Text('Last update on ' + DateFormat().format(weather.lastUpdate))
            ],
          )
        ],
      ),
    ));
  }
}
