import 'dart:convert';

class Organization {
  String name;
  String email;
  String password;
  List<String> address;
  List<String> donations;   //ID lang ng donations ang laman nito
  String phone;
  String proof;

  Organization({
    required this.name, 
    required this.email, 
    required this.password,
    required this.address,
    required this.donations,
    required this.phone,
    required this.proof
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      name: json['name'], 
      email: json['email'],
      password: "",
      address: List<String>.from(json['address']),
      donations: List<String>.from(json['donations']),
      phone: json['phone'],
      proof: json['proof']
    );
  }

  static List<Organization> fromJsonArray(String jsonData) {
    Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Organization>((dynamic d) => Organization.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'donations' : donations,
      'phone': phone,
      'proof': proof
    };
  }
}
