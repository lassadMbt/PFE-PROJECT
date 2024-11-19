// lib/repositories/get_places_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tataguid/models/place_model.dart';

class PlaceRepository {
  static const String baseUrl = 'http://192.168.1.10:8080';

Future<List<PlaceModel>> getAllPlaces() async {
  final response = await http.get(Uri.parse('$baseUrl/uploads/all-places'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    print(jsonResponse); // Log the response
    return jsonResponse.map((place) => PlaceModel.fromJson(place)).toList();
  } else {
    throw Exception('Failed to load places');
  }
}

  Future<PlaceModel> fetchPlaceById(String placeId) async { 
    try {
      final response = await http.get(Uri.parse('$baseUrl/uploads/places/$placeId'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return PlaceModel.fromJson(data);
      } else {
        throw Exception('Failed to load place details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load place details: $e');
    }
  }

  Future<void> deletePlaceById(String placeId, String userToken) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/uploads/delete/$placeId'),
      headers: {'Authorization': 'Bearer $userToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete place');
    }
  }
}