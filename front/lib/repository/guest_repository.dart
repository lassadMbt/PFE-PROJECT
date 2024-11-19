// frontend/lib/repository/guest_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class GuestRepository {
  static const String baseUrl = 'http://192.168.1.10:8080'; // Replace with your backend URL


  Future<String> generateGuestID() async {
    final response = await http.post(
      Uri.parse('$baseUrl/guests/generate-id-Guest'),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['guestID'];
    } else {
      throw Exception('Failed to generate guest ID');
    }
  }
}

