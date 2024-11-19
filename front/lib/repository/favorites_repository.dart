// lib/repository/favorites_repository.dart

import 'dart:convert';
import 'package:tataguid/models/place_model.dart';
import 'package:http/http.dart' as http;

class FavoritesRepository {
  static const String baseUrl = 'http://192.168.1.10:8080';

  Future<void> addFavorite(String userId, String placeId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/favorite/favorites'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'placeId': placeId}),
    );

    if (response.statusCode == 201) {
      print('Favorite added successfully');
    } else {
      throw Exception('Failed to add favorite: ${response.body}');
    }
  }

  Future<List<PlaceModel>> getFavorites(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/favorite/favorites/$userId'),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          final List<dynamic> data = jsonResponse
              .map((favoriteJson) => favoriteJson['placeId'])
              .toList();
          return data
              .map((placeJson) => PlaceModel.fromJson(placeJson))
              .toList();
        } else {
          throw Exception('Unexpected JSON format');
        }
      } else {
        throw Exception(
            'Failed to load favorites: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('An error occurred while fetching favorites: $e');
    }
  }
}
