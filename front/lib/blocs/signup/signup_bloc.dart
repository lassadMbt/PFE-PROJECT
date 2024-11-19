// lib/blocs/signup/signup_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:tataguid/blocs/signup/signup_event.dart';
import 'package:tataguid/blocs/signup/signup_state.dart';
import '../../repository/auth_repo.dart';

class SignupBloc extends Bloc<SignupEvents, SignupState> {
  final AuthRepository authRepository;

  SignupBloc({required this.authRepository}) : super(LogoutState()) {
    on<StartSignupEvent>(_onStartSignupEvent);
    on<TriggerEmailPasswordEvent>(_onTriggerEmailPasswordEvent);
    on<TriggerRoleSelectionEvent>(_onTriggerRoleSelectionEvent);
    on<SignupUserFieldsEvent>(_onTriggerUserFieldsEvent);
    on<SignupAgencyFieldsEvent>(_onTriggerAgencyFieldsEvent);
    on<FinalizeSignupEvent>(_onFinalizeSignupEvent);
  }

  Logger _logger = Logger();
  String? email;
  String? password;
  String? name;
  String? agencyName;
  String? type;
  String? language;
  String? country;
  String? location;
  String? description;
  String? PhoneNumber;

  void _onStartSignupEvent(
    StartSignupEvent event,
    Emitter<SignupState> emit,
  ) {
    emit(SignupInitState()); // Emit initial state
  }

  void _onTriggerEmailPasswordEvent(
    TriggerEmailPasswordEvent event,
    Emitter<SignupState> emit,
  ) async {
    email = event.email;
    password = event.password;
    emit(SignupLoadingState());
    print(email);
    print(password);
  }

  void _onTriggerRoleSelectionEvent(
    TriggerRoleSelectionEvent event,
    Emitter<SignupState> emit,
  ) async {
    type = event.type.toLowerCase(); // Ensure type is in lowercase
    emit(SignupRoleSelectedState(type!));
    if (type == 'user') {
      emit(SignupUserFieldsState(
        name: name ?? '',
        language: language ?? '',
        country: country ?? '',
      ));
    } else if (type == 'agency') {
      emit(SignupAgancyFieldsState(
        agencyName: agencyName ?? '',
        location: location ?? '',
        description: description ?? '',
        PhoneNumber: PhoneNumber ?? '',
      ));
    }
    print(type);

    // Update type in SignupBloc
    type = event.type.toLowerCase(); // Ensure type is in lowercase
  }

  void _onTriggerUserFieldsEvent(
    SignupUserFieldsEvent event,
    Emitter<SignupState> emit,
  ) async {
    if (type == null) {
      emit(SignupErrorState('Type is null'));
      print('Type is null');
      return;
    }
    emit(SignupRoleSelectedState(type!));
    name = event.name;
    language = event.language;
    country = event.country;
    emit(SignupLoadingState());
  }
void _onTriggerAgencyFieldsEvent(
    SignupAgencyFieldsEvent event,
    Emitter<SignupState> emit,
  ) async {
    if (type == null) {
      emit(SignupErrorState('Type is null'));
      print('agency type is null');
      return;
    }
    emit(SignupRoleSelectedState(type!));
    agencyName = event.agencyName;
    location = event.location;
    description = event.description;
    PhoneNumber = event.phoneNumber;
    emit(SignupLoadingState());
  }

  void _onFinalizeSignupEvent(
  FinalizeSignupEvent event,
  Emitter<SignupState> emit,
) async {
  emit(SignupLoadingState()); // Emit loading state before API call
  try {
    // Extract data from the event with fallback values from class properties
    String finalEmail = event.email.isEmpty ? email ?? '' : event.email;
    String finalPassword = event.password.isEmpty ? password ?? '' : event.password;
    String finalType = event.type.toLowerCase(); // Convert to lowercase
    String finalName = event.name.isEmpty ? name ?? '' : event.name;
    String finalAgencyName = event.agencyName.isEmpty ? agencyName ?? '' : event.agencyName;
    String finalLanguage = event.language.isEmpty ? language ?? '' : event.language;
    String finalCountry = event.country.isEmpty ? country ?? '' : event.country;
    String finalLocation = event.location.isEmpty ? location ?? '' : event.location;
    String finalDescription = event.description.isEmpty ? description ?? '' : event.description;
    String finalPhoneNumber = event.description.isEmpty ? PhoneNumber ?? '' : event.phoneNumber;

    if (finalEmail.isEmpty || finalPassword.isEmpty) {
      emit(SignupErrorState('Email and Password cannot be empty'));
      return;
    }

    // Create a map for the event data
    Map<String, dynamic> eventData = {
      'email': finalEmail,
      'password': finalPassword,
      'type': finalType,
      if (finalType == 'user') ...{
        'name': finalName,
        'language': finalLanguage,
        'country': finalCountry,
      } else if (finalType == 'agency') ...{
        'agencyName': finalAgencyName,
        'location': finalLocation,
        'description': finalDescription,
        'phoneNumber': finalPhoneNumber,
      }
    };

    _logger.i('eventData: $eventData');

    // Send sign-up request
    var data = await authRepository.signUp(eventData);

    _logger.i('data: $data');

    // Check response and emit appropriate state
    if (data['message'] == "User created successfully" && finalType == 'user') {
      emit(UserSignupSuccessState());
    } else if (data['message'] == "User created successfully" && finalType == 'agency') {
      emit(AgencySignupSuccessState());
    } else if (data['message'] == "This email is already used") {
      emit(EmailExistState('This email is already in use')); // Emit EmailExistState
    } else {
      emit(SignupErrorState('Something went wrong'));
    } 


  } catch (error) {
    _logger.e(error);
    emit(SignupErrorState(error.toString()));
  }
}
}
