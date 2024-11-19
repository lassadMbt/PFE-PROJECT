// lib/blocs/signup/signup_event.dart

import 'package:equatable/equatable.dart';

abstract class SignupEvents extends Equatable {
  @override
  List<Object> get props => [];
}

class StartSignupEvent extends SignupEvents {}

class TriggerEmailPasswordEvent extends SignupEvents {
  final String email;
  final String password;

  TriggerEmailPasswordEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class TriggerRoleSelectionEvent extends SignupEvents {
  final String type;

  TriggerRoleSelectionEvent({required this.type});

  @override
  List<Object> get props => [type];
}

class SignupUserFieldsEvent extends SignupEvents {
  final String name;
  final String language;
  final String country;

  SignupUserFieldsEvent({
    required this.name,
    required this.language,
    required this.country,
  });

  @override
  List<Object> get props => [name, country, language];
}

class SignupAgencyFieldsEvent extends SignupEvents {
  final String agencyName;
  final String location;
  final String description;
  final String phoneNumber;

  SignupAgencyFieldsEvent({
    required this.agencyName,
    required this.location,
    required this.description,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [agencyName, location, description, phoneNumber];
}

class FinalizeSignupEvent extends SignupEvents {
  final String email;
  final String password;
  final String name;
  final String agencyName;
  final String type;
  final String language;
  final String country;
  final String location;
  final String description;
  final String phoneNumber;

  FinalizeSignupEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.agencyName,
    required this.type,
    required this.language,
    required this.country,
    required this.location,
    required this.description,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [
        email,
        password,
        name,
        agencyName,
        type,
        language,
        country,
        location,
        description,
        phoneNumber,
      ];
}
