import 'dart:convert';

class Donation {
  List<String> category;
  String method;
  String weight;
  String photo;
  String date;
  String time;
  List<String> address;
  String phone;
  String status;
  String orgID;

  Donation({
    required this.category, 
    required this.method, 
    required this.weight,
    required this.photo,
    required this.date,
    required this.time,
    required this.address,
    required this.phone,
    required this.status,
    required this.orgID
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      category: List<String>.from(json['category']), 
      method: json['method'],
      weight: json['weight'],
      photo: json['photo'],
      date: json['date'],
      time: json['time'],
      address: List<String>.from(json['address']),
      phone: json['phone'],
      status: json['status'],
      orgID: json['orgID']
    );
  }

  static List<Donation> fromJsonArray(String jsonData) {
    Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donation>((dynamic d) => Donation.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'method': method,
      'weight': weight,
      'photo': photo,
      'date': date,
      'time': time,
      'address': address,
      'phone': phone,
      'status': status,
      'orgID':orgID
    };
  }
}
