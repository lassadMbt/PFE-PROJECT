// lib/blocs/profile/profile_event.dart

import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UploadProfileImage extends ProfileEvent {
  final File imageFile;
  final String token;
  final String email;

  const UploadProfileImage({
    required this.imageFile,
    required this.token,
    required this.email,
  });

  @override
  List<Object> get props => [imageFile, token, email];
}

class UpdateAgencyProfile extends ProfileEvent {
  final String email;
  final String token;
  final String? agencyName;
  final String? location;
  final String? description;
  final String? phoneNumber;

  const UpdateAgencyProfile({
    required this.email,
    required this.token,
    this.agencyName,
    this.location,
    this.description,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [email, token, agencyName, location, description, phoneNumber];
}
