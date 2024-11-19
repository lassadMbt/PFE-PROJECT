// lib/repository/auth_repo.dart

import 'dart:async';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:tataguid/repository/AuthResponse.dart';
import 'package:tataguid/storage/profil_storage.dart';
import '../storage/token_storage.dart';
import 'package:logger/logger.dart';

class AuthRepository {
  final TokenStorage tokenStorage = TokenStorage();
  static const String baseUrl = 'http://192.168.1.10:8080/auth';
  final logger = Logger();

  Future<AuthResponse> login(String email, String password) async {
    try {
      var res = await http
          .post(
            Uri.parse("$baseUrl/login"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': email,
              'password': password,
            }),
          )
          .timeout(Duration(seconds: 10)); // Adjust timeout duration as needed

      // logger.d('Response Body: ${res.body}'); // Log the response body

      final data = json.decode(res.body);
      if (data['token'] != null) {
        await TokenStorage.storeToken(data['token']);
        await TokenStorage.storeUserType(data['type']);

        if (data['type'] == 'agency' && data['id'] != null) {
          await TokenStorage.storeAgencyId(data['id']);
        }
        return AuthResponse.fromJson(data); // Use constructor to create object
      } else if (data['message'] != null) {
        throw new Exception(data['message']);
      } else {
        throw new Exception('Failed to login!');
      }
    } catch (e) {
      rethrow; // Rethrow the exception for handling in the UI
    }
  }

  Future<Map<String, dynamic>> signUp(Map<String, dynamic> eventData) async {
    try {
      // Log the data being sent for debugging
      print('Sending signup request with data: $eventData');

      var res = await http
          .post(
            Uri.parse("$baseUrl/signup"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(eventData),
          )
          .timeout(Duration(seconds: 10)); // Adjust timeout duration as needed

      // Log the response status code and body
      print('Received response with status code: ${res.statusCode}');
      print('Response body: ${res.body}');

      // Check the response status code
      if (res.statusCode == 201) {
        // If the request was successful, parse the response body
        final data = json.decode(res.body);
        // Check if the 'message' key exists in the response data
        if (data.containsKey('message')) {
          if (data['message'] == "User created successfully" ||
              data['message'] == "Agency created successfully") {
            await TokenStorage.storeUserType(data['type']);
            if (data['type'] == 'agency' && data['id'] != null) {
              await TokenStorage.storeAgencyId(data['id']);
            }
            if (eventData.containsKey('phoneNumber')) {
              await ProfileAgencyStorage.savePhoneNumber(
                  eventData['phoneNumber']);
            }
            return data; // Return the response data
          } else {
            // If the signup failed, return an error message
            return {"error": data['message']};
          }
        } else {
          // If the response does not contain the 'message' key, return an error message
          return {"error": "Invalid response from server"};
        }
      } else {
        // If the request was not successful (status code other than 201), return an error message
        return {"error": "Failed to sign up. Status code: ${res.statusCode}"};
      }
    } catch (e) {
      // If an exception occurs during the request, return an error message
      print('An error occurred during signup: $e');
      return {"error": "An error occurred: $e"};
    }
  }

  Future<AuthResponse> googleLogin(GoogleSignInAccount user) async {
    try {
      var res = await http
          .post(
            Uri.parse("$baseUrl/googleLogin"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'email': user.email,
              'idToken': (await user.authentication).idToken!,
            }),
          )
          .timeout(Duration(seconds: 10));

      final data = json.decode(res.body);
      if (data['token'] != null) {
        await TokenStorage.storeToken(data['token']);
        await TokenStorage.storeUserType(data['type']);

        if (data['type'] == 'agency' && data['id'] != null) {
          await TokenStorage.storeAgencyId(data['id']);
        }
        return AuthResponse.fromJson(data);
      } else if (data['message'] != null) {
        throw Exception(data['message']);
      } else {
        throw Exception('Failed to login with Google!');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getToken() async {
    return await TokenStorage.getToken();
  }
}
