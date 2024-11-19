// lib/models/favorite_model.dart

class FavoriteModel {
  final String userId;
  final String placeId;

  FavoriteModel({required this.userId, required this.placeId});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      userId: json['userId'],
      placeId: json['placeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'placeId': placeId,
    };
  }
}
