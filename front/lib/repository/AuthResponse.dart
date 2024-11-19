// lib/repository/AuthResponse.dart
class AuthResponse {
  String token = "";
  String type = "";
  String email = "";
  String name = ""; 
  String agencyName = ""; 

  AuthResponse({required this.token, required this.type, required this.email, required this.name, required this.agencyName});

factory AuthResponse.fromJson(Map<String, dynamic> json) {
  return AuthResponse(
    token: json['token'] ?? "",
    type: json['type'] ?? "",
    email: json['email'] ?? "",
    name: json['name'] ?? "",
    agencyName: json['agencyName'] ?? "",
  );
}

}