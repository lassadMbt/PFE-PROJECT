/* // lib/models/booking.dart

class BookingModel {
  String? id;
  String? userId;
  String? placeId;
  String? agencyId;
  DateTime? bookingDate;
  String? status;
  String? notes;

  BookingModel({
    this.id,
    this.userId,
    this.placeId,
    this.agencyId,
    this.bookingDate,
    this.status,
    this.notes,
  });

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['bookingId'] ?? json['_id'];  // Handle both possible keys
    userId = json['userId'];
    placeId = json['placeId'];
    agencyId = json['agencyId'];
    bookingDate = json['visitDate'] != null ? DateTime.parse(json['visitDate']) : null;
    status = json['status'];
    notes = json['notes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['placeId'] = placeId;
    data['agencyId'] = agencyId;
    data['visitDate'] = bookingDate?.toIso8601String();
    data['status'] = status;
    data['notes'] = notes;
    return data;
  }
}
 */
// lib/models/booking.dart
class BookingModel {
  String? id;
  String? userId;
  String? userName;
  String? userEmail;
  String? placeId;
  String? placeName;
  String? title;
  String? agencyId;
  DateTime? bookingDate;
  double? price;
  String? notes;
  String? img;
  List<String>? tags;

  BookingModel({
    this.id,
    this.userId,
    this.userName,
    this.userEmail,
    this.placeId,
    this.placeName,
    this.title,
    this.agencyId,
    this.bookingDate,
    this.price,
    this.notes,
    this.img,
    this.tags,
  });

  BookingModel.fromJson(Map<String, dynamic> json) {
    id = json['bookingId'] ?? json['_id'];
    userId = json['userId'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    placeId = json['placeId'];
    placeName = json['placeName'];
    title = json['title'];
    agencyId = json['agencyId'];
    bookingDate = json['visitDate'] != null ? DateTime.parse(json['visitDate']) : null;
    price = json['price']?.toDouble();
    notes = json['notes'];
    img = json['img'];
    tags = json['tags'] != null ? List<String>.from(json['tags']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['userId'] = userId;
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    data['placeId'] = placeId;
    data['placeName'] = placeName;
    data['title'] = title;
    data['agencyId'] = agencyId;
    data['visitDate'] = bookingDate?.toIso8601String();
    data['price'] = price;
    data['notes'] = notes;
    data['img'] = img;
    data['tags'] = tags;
    return data;
  }

  @override
  String toString() {
    return 'BookingModel{id: $id, userId: $userId, userName: $userName, userEmail: $userEmail, placeId: $placeId, placeName: $placeName, title: $title, agencyId: $agencyId, bookingDate: $bookingDate, price: $price, notes: $notes, img: $img, tags: $tags}';
  }
}
