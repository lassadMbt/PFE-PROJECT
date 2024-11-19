// lib/repository/booking_repository.dart

import 'package:tataguid/models/booking.dart';
import 'package:http/http.dart' as http;
import 'package:tataguid/models/place_model.dart';
import 'package:tataguid/storage/profil_storage.dart';
import 'dart:convert';

import 'package:tataguid/storage/token_storage.dart';
class BookingRepository {
  static const String baseUrl = 'http://192.168.1.10:8080';

   Future<List<BookingModel>> fetchAgencyBookings(String agencyId) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/booking/getAgencyBookings/$agencyId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    print('Fetching agency bookings...');
    print('URL: $baseUrl/booking/getAgencyBookings/$agencyId');
    print('Token: $token');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        final responseBody = json.decode(response.body);

        if (responseBody is List) {
          return responseBody.map((json) => BookingModel.fromJson(json)).toList();
        } else if (responseBody is Map) {
          // Assuming the map might contain a key that holds the list of bookings
          if (responseBody.containsKey('bookings')) {
            final List<dynamic>? bookingsJson = responseBody['bookings'];
            if (bookingsJson != null) {
              return bookingsJson.map((json) => BookingModel.fromJson(json)).toList();
            } else {
              throw Exception('Expected list of bookings in response but got null');
            }
          } else {
            throw Exception('Response map does not contain bookings key');
          }
        } else {
          throw Exception('Unexpected response format: ${responseBody.runtimeType}');
        }
      } catch (e) {
        print('Error parsing response: $e');
        throw Exception('Failed to parse agency bookings: $e');
      }
    } else {
      throw Exception('Failed to load agency bookings');
    }
  }


  Future<List<BookingModel>> fetchBookings() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/booking/getAgencyBookings'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body)['bookings'];
      List<BookingModel> bookings =
          body.map((dynamic item) => BookingModel.fromJson(item)).toList();
      return bookings;
    } else {
      print('Failed to load bookings with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load bookings');
    }
  }

  Future<List<BookingModel>> fetchUserBookings() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/booking/getUserBookings'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body)['bookings'];
      List<BookingModel> bookings =
          body.map((dynamic item) => BookingModel.fromJson(item)).toList();
      return bookings;
    } else {
      throw Exception('Failed to load user bookings');
    }
  }


  Future<BookingModel> addBooking(BookingModel booking, String userId, PlaceModel place) async {
    final token = await TokenStorage.getToken();
    final agencyId = await TokenStorage.getAgencyId();
    final userName = await ProfileUserStorage.getUserName();
    final userEmail = await ProfileUserStorage.getUserEmail();
    final image = await ProfileUserStorage.getProfileImage(userEmail!);
    print("Token: $token");
    print("Adding booking with data: ${json.encode({
          'placeId': booking.placeId,
          'agencyId': agencyId,
          'visitDate': booking.bookingDate?.toIso8601String(),
          'userId': userId,
          'userName': userName,
          'userEmail': userEmail,
        })}");
    final response = await http.post(
      Uri.parse('$baseUrl/booking/createBooking'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'placeId': booking.placeId,
        'agencyId': booking.agencyId,
        'visitDate': booking.bookingDate?.toIso8601String(),
        'userId': userId,
        "placeName": place.placeName,
        'img': image ?? 'assets/Profileimage.png',
        "title": place.title,
        "price": place.price,
        "userName": userName,
        "userEmail": userEmail
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 201) {
      return BookingModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception(json.decode(response.body)['message']);
    } else {
      throw Exception('Failed to add booking');
    }
  }


Future<PlaceModel> fetchPlace(String placeId) async {
  final Uri uri = Uri.parse('$baseUrl/uploads/places/$placeId');
  print('Fetching place with ID: $placeId from URL: $uri'); // Log the placeId and URL
  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return PlaceModel.fromJson(json.decode(response.body));
    } else {
      print('Failed to load place: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load place');
    }
  } catch (error) {
    print('Error fetching place: $error');
    throw Exception('Failed to load place');
  }
}




  Future<BookingModel> updateBooking(BookingModel booking) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/booking/updateBooking/${booking.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(booking.toJson()),
    );

    if (response.statusCode == 200) {
      return BookingModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update booking');
    }
  }

  Future<void> deleteBooking(String bookingId) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/booking/cancelBooking/$bookingId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete booking');
    }
  }
}
