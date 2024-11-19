// lib/main.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tataguid/agencyPages/ProfilePages/general_information_page.dart';
import 'package:tataguid/agencyPages/ProfilePages/offers_promotions_page.dart';
import 'package:tataguid/agencyPages/ProfilePages/settings_page.dart';
import 'package:tataguid/agencyPages/homePage.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_bloc.dart';
import 'package:tataguid/blocs/Chat/chat_bloc.dart';
import 'package:tataguid/blocs/favorite/favorite_bloc.dart';
import 'package:tataguid/blocs/getPlace/get_place_bloc.dart';
import 'package:tataguid/blocs/guest/guest_bloc.dart';
import 'package:tataguid/blocs/login/login_bloc.dart';
import 'package:tataguid/blocs/profile/profile_bloc.dart';
import 'package:tataguid/blocs/resetPassword/reset_password_bloc.dart';
import 'package:tataguid/blocs/signup/signup_bloc.dart';
import 'package:tataguid/blocs/uploadBloc/upload_bloc.dart';
import 'package:tataguid/components/theme_manager.dart';
import 'package:tataguid/pages/onboarding_page.dart';
import 'package:tataguid/repository/auth_repo.dart';
import 'package:tataguid/repository/booking_repository.dart';
import 'package:tataguid/repository/chat_repository.dart';
import 'package:tataguid/repository/favorites_repository.dart';
import 'package:tataguid/repository/get_places_repository.dart';
import 'package:tataguid/repository/guest_repository.dart';
import 'package:tataguid/repository/password_reset_repo.dart';
import 'package:tataguid/repository/profil_repo.dart';
import 'package:tataguid/repository/upload_repository.dart';
import 'package:tataguid/storage/profil_storage.dart';
import 'package:tataguid/storage/token_storage.dart';
import 'package:tataguid/ui/LoginUi.dart';
import 'package:tataguid/ui/get_contacts.dart';
import 'package:tataguid/ui/post_contacts.dart';

void main() => runApp(TataGuid());

class TataGuid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    final ForgotPasswordRepository forgotPasswordRepository = ForgotPasswordRepository();
    final ProfileRepository profileRepository = ProfileRepository();
    final GuestRepository guestRepository = GuestRepository();
    final UploadRepository uploadRepository = UploadRepository();
    final PlaceRepository placeRepository = PlaceRepository();
    final BookingRepository bookingRepository = BookingRepository();
    final ChatRepository chatRepository = ChatRepository();
    final FavoritesRepository favoritesRepository = FavoritesRepository();

    return MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: authRepository),
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(authRepository: authRepository),
        ),
        BlocProvider<SignupBloc>(
          create: (context) => SignupBloc(authRepository: authRepository),
        ),
        BlocProvider<ResetPasswordBloc>(
          create: (context) => ResetPasswordBloc(
              forgotPasswordRepository: forgotPasswordRepository),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) =>
              ProfileBloc(profileRepository: profileRepository),
        ),
        BlocProvider<GuestBloc>(
          create: (context) => GuestBloc(guestRepository: guestRepository),
        ),
        BlocProvider<UploadBloc>(
          create: (context) => UploadBloc(uploadRepository: uploadRepository),
        ),
        BlocProvider<PlaceBloc>(
          create: (context) => PlaceBloc(placeRepository: placeRepository),
        ),
        BlocProvider<BookingBloc>(
          create: (context) =>
              BookingBloc(bookingRepository: bookingRepository),
        ),
        BlocProvider<ChatBloc>(
          create: (context) =>
              ChatBloc(chatRepository: chatRepository),
        ),
        BlocProvider<FavoriteBloc>(
          create: (context) =>
              FavoriteBloc(favoritesRepository: favoritesRepository),
        ),
        ChangeNotifierProvider<ThemeManager>(
          create: (context) => ThemeManager(),
        ),
      ],
      child: Consumer<ThemeManager>(
        builder: (context, themeManager, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeManager.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            initialRoute: '/',
            routes: {
              '/': (context) => OnboardingPage(),
              '/user_dashboard': (context) => UserPage(),
              '/agency_panel': (context) => AgencyPanelScreen(),
              '/login_ui': (context) => LoginUi(),
              '/Guest': (context) => UserPage(),
              '/general_information': (context) => FutureBuilder<List<String?>>(
                future: Future.wait([
                  ProfileAgencyStorage.getAgencyEmail(), 
                  TokenStorage.getToken()
                ]),
                builder: (context, AsyncSnapshot<List<String?>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Scaffold(
                      body: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  } else {
                    final email = snapshot.data![0] ?? ''; // Provide default value
                    final token = snapshot.data![1] ?? ''; // Provide default value
                    return GeneralInformationPage(email: email, token: token);
                  }
                },
              ),
              '/offers_promotions': (context) => OffersPromotionsPage(),
              '/settings': (context) => SettingsPage(),
              '/agency_home': (context) => AgencyHome(),
            },
            onGenerateRoute: (settings) {
              if (Platform.isAndroid || Platform.isIOS) {
                return MaterialPageRoute(
                  builder: (context) => PlatformErrorScreen(),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}

class PlatformErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Platform Error'),
      ),
      body: Center(
        child: Text(
          'Unsupported operation: Platform._operatingSystem',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
