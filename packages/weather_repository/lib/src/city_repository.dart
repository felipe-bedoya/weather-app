import 'models/models.dart';
import 'provider/data_provider.dart';

class CityRepository {
  final provider = DataProvider();
  int _page = 0;
  List<City> cities = List();
  String lastSearch = '';

  Future<List<City>> fetchCities(String token) async {
    final cities = await provider.fetchCities(_page, token);
    _page++;
    this.cities.addAll(cities);
    final newCities = List<City>();
    newCities.addAll(this.cities);
    return newCities;
  }

  Future<List<City>> search(String text, String token) async {
    lastSearch = text;
    return provider.search(text, token);
  }
}
