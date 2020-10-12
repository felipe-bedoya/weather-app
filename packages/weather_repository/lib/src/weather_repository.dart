import 'models/models.dart';
import 'provider/data_provider.dart';

class WeatherRepository {
  final provider = DataProvider();

  List<Weather> weathers = List();

  Future<List<Weather>> subscriptions(String token) async {
    this.weathers = await provider.subscriptions(token);
    return this.weathers;
  }

  Future<bool> subscribe(String city, String user,String token) async {
    return provider.subscribe(city, user,token);
  }

  Future<bool> unsubscribe(String city, String user, String token) async {
    return provider.unsubscribe(city, user, token);
  }
}