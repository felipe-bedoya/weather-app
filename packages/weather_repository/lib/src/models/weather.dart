import 'city.dart';

class Weather {
  final double temperature;
  final double humidity;
  final String description;
  final String icon;
  final City city;
  final DateTime lastUpdate;

  Weather(this.temperature, this.humidity, this.description, this.icon,
      this.city, this.lastUpdate);

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        (json['temperature'] as num).toDouble(),
        (json['humidity'] as num).toDouble(),
        json['description'],
        json['icon'],
        City.fromJson(json['city']),
        DateTime.fromMillisecondsSinceEpoch(json['lastUpdate']));
  }
}
