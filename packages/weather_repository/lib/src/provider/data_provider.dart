import '../models/models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DataProvider {
  Future<List<Weather>> subscriptions(String token) async {
    final headers = {
      "Authorization": "Bearer " + token,
      "accept": "application/json"
    };
    final response =
        await http.get('http://192.168.0.6:3000/api/weather', headers: headers);
    if (response.statusCode == 200) {
      final subscriptions = List<Weather>();
      final json = jsonDecode(response.body) as List;
      json.forEach((e) {
        subscriptions.add(Weather.fromJson(e));
      });
      return subscriptions;
    } else {
      return List();
    }
  }

  Future<bool> subscribe(String city, String user, String token) async {
    final headers = {
      "Authorization": "Bearer " + token,
      "Content-Type": "application/json"
    };
    final data = {'user': user, 'city': city};
    final body = json.encode(data);
    final encoding = Encoding.getByName('utf-8');
    final response = await http.post('http://192.168.0.6:3000/api/subscription',
        headers: headers, body: body, encoding: encoding);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> unsubscribe(String city, String user,String token) async {
    final headers = {
      "Authorization": "Bearer " + token,
      "Content-Type": "application/json"
    };
    final data = {'user': user, 'city': city};
    final body = json.encode(data);
    final encoding = Encoding.getByName('utf-8');
    final response = await http.post(
        'http://192.168.0.6:3000/api/subscription/delete',
        headers: headers,
        body: body,
        encoding: encoding);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<City>> fetchCities(
      int page, String token) async {
    final headers = {
      "Authorization": "Bearer " + token,
      "accept": "application/json"
    };
    final response = await http.get(
        'http://192.168.0.6:3000/api/cities/' + page.toString(),
        headers: headers);
    if (response.statusCode == 200) {
      final cities = List<City>();
      final json = jsonDecode(response.body) as List;
      json.forEach((e) {
        cities.add(City.fromJson(e));
      });
      return cities;
    } else {
      throw Exception('Failed to fetch cities');
    }
  }

  Future<List<City>> search(String text, String token) async {
    final headers = {
      "Authorization": "Bearer " + token,
      "accept": "application/json"
    };
    final response = await http.get(
        'http://192.168.0.6:3000/api/cities/search/' + text,
        headers: headers);
    if (response.statusCode == 200) {
      final cities = List<City>();
      final json = jsonDecode(response.body) as List;
      json.forEach((e) {
        cities.add(City.fromJson(e));
      });
      return cities;
    } else {
      throw Exception('Failed to fetch cities');
    }
  }
}
