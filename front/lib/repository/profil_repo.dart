// lib/ripository/profile_repo.dart

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:tataguid/storage/profil_storage.dart';

class ProfileRepository {
  static const String baseUrl = 'http://192.168.1.10:8080/profile'; // Replace with your backend URL

 Future<String> uploadProfileImage(
    File imageFile, String token, String email) async {
  try {
    final url = Uri.parse('$baseUrl/add/image/$email');
    final request = http.MultipartRequest('PATCH', url);
    request.headers['authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath(
      'img',
      imageFile.path,
      contentType: MediaType('image', 'jpg'),
    ));

    final response = await request.send();
//    print('Response status code: ${response.statusCode}');

    final responseData = await response.stream.bytesToString();
    // print('Response data: $responseData');

    if (response.statusCode == 200) {
      final parsedData = json.decode(responseData);
      final imgUrl = parsedData['data']['img'];
      // print('Image URL: $imgUrl');
      return imgUrl;
    } else {
      await ProfileUserStorage.storeEmail(email);
      throw Exception('Failed to upload profile image');
    }
  } catch (error) {
    await ProfileUserStorage.storeEmail(email);
    throw error;
  }
}
 Future<void> updateAgencyProfile(String email, String token, String? agencyName, String? location, String? description, String? phoneNumber) async {
    try {
      final url = Uri.parse('$baseUrl/update/agency/$email');
      Map<String, dynamic> updateFields = {};

      if (agencyName != null) updateFields['agencyName'] = agencyName;
      if (location != null) updateFields['location'] = location;
      if (description != null) updateFields['description'] = description;
      if (phoneNumber != null) updateFields['phoneNumber'] = phoneNumber;

      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateFields),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      throw error;
    }
  }
}