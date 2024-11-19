// lib/models/upload.dart

class UploadModel {
  String? agencyId;
  String? title;
  String? placeName;
  String? StartEndPoint;
  List<String>? photos;
  String? visitDate;
  double? price;
  String? description;
  String? duration;
  String? HotelName;
  String? CheckInOut;
  String? accessibility;
  String? phoneNumber;

  UploadModel({
    this.agencyId,
    this.title,
    this.placeName,
    this.photos,
    this.StartEndPoint,
    this.visitDate,
    this.price,
    this.description,
    this.duration,
    this.HotelName,
    this.CheckInOut,
    this.accessibility,
    this.phoneNumber,
  });

  UploadModel.fromJson(Map<String, dynamic> json) {
    agencyId = json['agencyId'];
    title = json['title'];
    placeName = json['placeName'];
    StartEndPoint = json['StartEndPoint'];
    photos = List<String>.from(json['photos']);
    visitDate = json['visitDate'];
    price = json['price']?.toDouble();
    description = json['description'];
    duration = json['duration'];
    HotelName = json['HotelName'];
    CheckInOut = json['CheckInOut'];
    accessibility = json['accessibility'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['agencyId'] = this.agencyId;
    data['title'] = this.title;
    data['placeName'] = this.placeName;
    data['StartEndPoint'] = this.StartEndPoint;
    data['photos'] = this.photos;
    data['visitDate'] = this.visitDate;
    data['price'] = this.price;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['HotelName'] = this.HotelName;
    data['CheckInOut'] = this.CheckInOut;
    data['accessibility'] = this.accessibility;
    data['phoneNumber'] = this.phoneNumber;
    return data;
  }
}
