// lib/storage/profil_storage.dart

import 'package:shared_preferences/shared_preferences.dart';

class ProfileUserStorage {
  static Future<void> storeDefaultProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('default_profile_image_path', 'assets/Profileimage.png');
  }

  static Future<void> storeProfileImage(String email, String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image_path_$email', imagePath);
  }

  static Future<String?> getProfileImage(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image_path_$email');
    if (imagePath == null) {
      imagePath = prefs.getString('default_profile_image_path');
    }
    return imagePath;
  }

  static Future<void> deleteProfileImage(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('profile_image_path_$email');
  }

  static Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  static Future<void> storeEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_email', email);
  }

  static Future<void> clearDefaultProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('default_profile_image_path');
  }

  static Future<void> storeUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_name', name);
  }

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<void> setProfileImage(String email, String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image_path_$email', path);
  }
}



class ProfileAgencyStorage{
  static const String _agencyIdKey = 'agencyId';

   static Future<void> storeAgencyId(String agencyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_agencyIdKey, agencyId);
  }

  static Future<String?> getAgencyId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_agencyIdKey);
  }


  static Future<void> storeAgencyEmail(String email) async {
    // Store the agency's name
   SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('agency_email', email);
  }


   static Future<String?> getAgencyEmail() async {
    // Retrieve the agency's email
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('agency_email');
  }


  static Future<void> storeAgencyName(String agencyName) async {
    // Store the agency's name
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('agency_name', agencyName);
  }

  static Future<String?> getAgencyName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('agency_name');
    
  }

   static Future<void> savePhoneNumber(String phoneNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', phoneNumber);
  }

  static Future<String?> getPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phoneNumber');
  }


}