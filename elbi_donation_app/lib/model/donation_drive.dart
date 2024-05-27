import 'dart:convert';

class DonationDrive {
  String name;
  String organizationID;
  List<String> donationID;

  DonationDrive({
    required this.name,
    required this.organizationID,
    required this.donationID,
  });

  factory DonationDrive.fromJson(Map<String, dynamic> json) {
    return DonationDrive(
      name: json['name'] ?? '', // Provide a default value if 'name' is null
      organizationID: json['organizationID'] ?? '',
      donationID: List<String>.from(json['donationID']),
    );
  }

  static List<DonationDrive> fromJsonArray(String jsonData) {
    Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<DonationDrive>((dynamic d) => DonationDrive.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(DonationDrive drive) {
    return {
      'name': name,
      'organizationID': organizationID,
      'donationID': donationID,
    };
  }
}
