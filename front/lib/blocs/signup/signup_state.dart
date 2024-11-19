// lib/blocs/signup/signup_state.dart

import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class LogoutState extends SignupState {}

class SignupInitState extends SignupState {}

class SignupLoadingState extends SignupState {}


class SignupSuccessState extends SignupState {}

class SignupErrorState extends SignupState {
  final String message;

  const SignupErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class UserSignupSuccessState extends SignupState {}

class AgencySignupSuccessState extends SignupState {}

class EmailPasswordProcessedState extends SignupState {}

class EmailExistState extends SignupState {
    final String Existmessage;
const EmailExistState(this.Existmessage);

  @override
  List<Object> get props => [Existmessage];
}




class SignupRoleSelectedState extends SignupState {
  final String type;

  const SignupRoleSelectedState(this.type);

  @override
  List<Object> get props => [type];
}

class SignupUserFieldsState extends SignupState {
  final String name;
  final String language;
  final String country;
 
  const SignupUserFieldsState({
    required this.name,
    required this.language,
    required this.country,
  });

  @override
  List<Object> get props => [name, language, country]; 
}


class SignupAgancyFieldsState extends SignupState {
  final String agencyName;
  final String location;
  final String description;
  final String PhoneNumber;

  const SignupAgancyFieldsState({
    required this.agencyName,
    required this.location,
    required this.description,
    required this.PhoneNumber,
  });

  @override
  List<Object> get props => [agencyName, location, description, PhoneNumber]; 
}

class FinalizeSignupState extends SignupState {
   final String name;
  final String language;
  final String country;
  final String agencyName;
  final String location;
  final String description;
  final String PhoneNumber;

  const FinalizeSignupState({
     required this.name,
    required this.language,
    required this.country,
    required this.agencyName,
    required this.location,
    required this.description,
    required this.PhoneNumber,
  });

  @override
  List<Object> get props => [agencyName, location, description, name, language, country, PhoneNumber];
}
