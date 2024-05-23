import 'dart:convert';

class Person {
  String name;
  String email;
  String password;
  List<String> address;
  List<String> donations;   //ID lang ng Persons ang laman nito
  String phone;

  Person({
    required this.name, 
    required this.email, 
    required this.password,
    required this.address,
    required this.donations,
    required this.phone
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      name: json['name'], 
      email: json['email'],
      password: json['password'],
      address: List<String>.from(json['address']),
      donations: List<String>.from(json['donations']),
      phone: json['phone']
    );
  }

  static List<Person> fromJsonArray(String jsonData) {
    Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Person>((dynamic d) => Person.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'donations' : donations,
      'phone': phone,
    };
  }
}
