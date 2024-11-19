// lib/repository/upload_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class UploadRepository {
  static const String baseUrl = 'http://192.168.1.10:8080'; // Replace with your backend URL

  // Method for adding a new place
  static Future<void> addPlace(String agencyId, Map<String, dynamic> data, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/uploads/add-places'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201) {
      // Place added successfully
      print('Place added successfully');
    } else {
      print('Error adding place: ${response.statusCode}');
      print('Response body: ${response.body}'); // Log response body for more details
    
    }
  }

  // Method for updating a place by ID
  static Future<void> updatePlace(String id, Map<String, dynamic> data, String token) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/update/$id'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Place updated successfully
      print('Place updated successfully');
    } else {
      // Error occurred
      print('Error updating place: ${response.statusCode}');
    }
  }

  // Method for deleting a place by ID
  static Future<void> deletePlace(String id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Place deleted successfully
      print('Place deleted successfully');
    } else {
      // Error occurred
      print('Error deleting place: ${response.statusCode}');
    }
  }

  // Method for getting all places
  static Future<String?> getAllPlaces(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get-places'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Places retrieved successfully
      return response.body;
    } else {
      // Error occurred
      print('Error getting places: ${response.statusCode}');
      return null;
    }
  }

  // Method for getting a place by ID
  static Future<dynamic> getPlaceById(String id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/places/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Place retrieved successfully
      return response.body;
    } else {
      // Error occurred
      print('Error getting place: ${response.statusCode}');
      return null;
    }
  }
}
