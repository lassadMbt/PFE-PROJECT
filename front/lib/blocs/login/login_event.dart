// lib/blocs/login/login_event.dart

import 'package:equatable/equatable.dart';
import 'package:google_sign_in/google_sign_in.dart';


abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  // final String type; 


  const LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object> get props => [email, password/* , type */];
}

class NavigateToLogin extends LoginEvent {
  const NavigateToLogin();
}

class LogoutEvent extends LoginEvent {}

class GoogleSignInEvent extends LoginEvent {
  final dynamic user;

  const GoogleSignInEvent({required this.user});

  @override
    List<Object> get props => [user];
}
