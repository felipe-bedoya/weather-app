import 'package:equatable/equatable.dart';

class City extends Equatable {
  final String id;
  final String name;
  final String state;
  final String country;

  City({this.id, this.name, this.state, this.country});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      state: json['state'],
      country: json['country'],
    );
  }

  @override
  List<Object> get props => [id, name, state, country];
}