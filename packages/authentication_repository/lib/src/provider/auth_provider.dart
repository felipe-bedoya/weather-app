import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthProvider {
  Future<String> login(String username, String password) async{
    final headers = {
      "accept": "application/json",
      "Content-Type": "application/json"
    };
    final data = {'username': username, 'password': password};
    final body = jsonEncode(data);
    final encoding = Encoding.getByName('utf-8');
    print(body);
    final response = await http.post('http://192.168.0.6:3000/api/auth/login',
        headers: headers, body: body, encoding: encoding);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      return '';
    }
  }
}