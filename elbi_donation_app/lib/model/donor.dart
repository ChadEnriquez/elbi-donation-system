import 'dart:convert';

class Donor {
  String name;
  String email;
  String password;
  List<String> address;
  List<String> donations;   //ID lang ng Donors ang laman nito
  String contactno;

  Donor({
    required this.name, 
    required this.email, 
    required this.password,
    required this.address,
    required this.donations,
    required this.contactno
  });

  factory Donor.fromJson(Map<String, dynamic> json) {
  return Donor(
    name: json['name'] ?? '', // Provide a default value if 'name' is null
    email: json['email'] ?? '',
    password: json['password'] ?? '', // Provide a default value or handle password separately
    address: List<String>.from(json['address'] ?? []),
    donations: List<String>.from(json['donations'] ?? []),
    contactno: json['contactno'] ?? '',
  );
}


  static List<Donor> fromJsonArray(String jsonData) {
    Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donor>((dynamic d) => Donor.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'donations' : donations,
      'contactno': contactno,
    };
  }
}
