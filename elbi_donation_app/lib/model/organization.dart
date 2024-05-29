import 'dart:convert';

class Organization {
  String name;
  String email;
  String password;
  String description; 
  List<String> address;
  List<String> donations;   // ID lang ng donations ang laman nito
  List<String> donationDrives;
  String contactno;
  String proof;

  Organization({
    required this.name, 
    required this.email, 
    required this.password,
    required this.description, 
    required this.address,
    required this.donations,
    required this.donationDrives,
    required this.contactno,
    required this.proof
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      name: json['name'], 
      email: json['email'],
      password: "",  
      description: json['description'], 
      address: List<String>.from(json['address']),
      donations: List<String>.from(json['donations']),
      donationDrives: List<String>.from(json['donationDrives']),
      contactno: json['phone'],
      proof: json['proof']
    );
  }

  static List<Organization> fromJsonArray(String jsonData) {
    Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Organization>((dynamic d) => Organization.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Organization organization) {
    return {
      'name': name,
      'email': email,
      'password': password,
      'description': description, 
      'address': address,
      'donations': donations,
      'donation_drives': donationDrives,
      'contactno': contactno,
      'proof': proof
    };
  }
}
