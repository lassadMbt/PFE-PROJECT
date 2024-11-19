// lib/models/model.dart

class User {
  String? id;
  String? email;
  String? password;
  String? name;
  String? language;
  String? country;
  String? type;
  String? agencyName;
  String? location;
  String? description;
  String? phoneNumber;
  String? token;

  User({
    this.id,
    this.email,
    this.password,
    this.name,
    this.language,
    this.country,
    this.type,
    this.agencyName,
    this.location,
    this.description,
    this.phoneNumber,
    this.token,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    email = json['email']?.toString();
    password = json['password'];
    name = json['name']?.toString();
    language = json['language'];
    country = json['country'];
    type = json['type'];
    agencyName = json['agencyName'];
    location = json['location'];
    description = json['description'];
    phoneNumber = json['phoneNumber'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['email'] = email;
    data['password'] = password;
    data['name'] = name;
    data['language'] = language;
    data['country'] = country;
    data['type'] = type;
    data['agencyName'] = agencyName;
    data['location'] = location;
    data['description'] = description;
    data['phoneNumber'] = phoneNumber;
    data['token'] = token;
    return data;
  }
}
