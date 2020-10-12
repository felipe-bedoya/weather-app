import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/models.dart';

class UserRepository {
  User _user;

  Future<User> fetchUser(String token) async {
    final headers = {
      "accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer " + token,
    };
    final response = await http.get('http://192.168.0.6:3000/api/users/me', headers: headers);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _user = User.fromJson(json);
      return _user;
    } else {
      _user = null;
    }
    return _user;
  }

  Future<User> getUser() async {
    return _user;
  }
}