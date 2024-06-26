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
  bool approval;
  bool status;

  Organization({
    required this.name, 
    required this.email, 
    required this.password,
    required this.description, 
    required this.address,
    required this.donations,
    required this.donationDrives,
    required this.contactno,
    required this.proof,
    required this.approval, 
    required this.status
  });

  factory Organization.fromJson(Map<String, dynamic> json) {
  return Organization(
    name: json['name'] ?? "", 
    email: json['email'] ?? "",
    password: "",  
    description: json['description'] ?? "", 
    address: json['address'] != null ? List<String>.from(json['address'] ?? []) : [],
    donations: json['donations'] != null ? List<String>.from(json['donations'] ?? []) : [],
    donationDrives: json['donationDrives'] != null ? List<String>.from(json['donationDrives'] ?? []) : [],
    contactno: json['phone'] ?? "",
    proof: json['proof'] ?? "",
    approval: json['approval'],
    status: json['status']
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
      'proof': proof,
      'approval': approval, 
      'status': status
    };
  }
}
