import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String token;

  User({this.id, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], token: json['token']);
  }

  @override
  List<Object> get props => [id, token];
}
