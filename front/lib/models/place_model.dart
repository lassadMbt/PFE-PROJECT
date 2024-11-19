// lib/models/Place.model.dart

class PlaceModel {
  final String id;
  final String title;
  final String placeName;
  final String startEndPoint;
  final List<String> photos;
  final String visitDate;
  final double price;
  final String description;
  final String duration;
  final String hotelName;
  final String checkInOut;
  final String accessibility;
  final List<String> tags;
  final String phoneNumber;
  final agencyName;

  PlaceModel({
    required this.id,
    required this.title,
    required this.placeName,
    required this.startEndPoint,
    required this.photos,
    required this.visitDate,
    required this.price,
    required this.description,
    required this.duration,
    required this.hotelName,
    required this.checkInOut,
    required this.accessibility,
    required this.tags,
    required this.phoneNumber,
    this.agencyName,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['_id'],
      title: json['title'],
      placeName: json['placeName'],
      startEndPoint: json['StartEndPoint'],
      photos: List<String>.from(json['photos']),
      visitDate: json['visitDate'],
      price: json['price'].toDouble(),
      description: json['description'],
      duration: json['duration'],
      hotelName: json['HotelName'] ?? '',
      checkInOut: json['CheckInOut'] ?? '',
      accessibility: json['accessibility'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      phoneNumber: json['phoneNumber'] ?? '',
      agencyName: json['agencyName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['title'] = title;
    data['placeName'] = placeName;
    data['StartEndPoint'] = startEndPoint;
    data['photos'] = photos;
    data['visitDate'] = visitDate;
    data['price'] = price;
    data['description'] = description;
    data['duration'] = duration;
    data['HotelName'] = hotelName;
    data['CheckInOut'] = checkInOut;
    data['accessibility'] = accessibility;
    data['tags'] = tags;
    data['phoneNumber'] = phoneNumber;
    data['agencyName'] = agencyName;
    return data;
  }
}
