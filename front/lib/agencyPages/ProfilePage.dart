// lib/agencyPages/profilePage.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/agencyPages/ProfilePages/agency_places_page.dart';
import 'package:tataguid/agencyPages/ProfilePages/general_information_page.dart';
import 'package:tataguid/blocs/profile/profile_bloc.dart';
import 'package:tataguid/blocs/profile/profile_event.dart';
import 'package:tataguid/storage/profil_storage.dart';
import 'package:tataguid/storage/token_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tataguid/blocs/login/login_bloc.dart';
import 'package:tataguid/blocs/login/login_event.dart';
import 'package:tataguid/blocs/login/login_state.dart';
import 'dart:io';

class AgencyProfile extends StatefulWidget {
  const AgencyProfile({super.key});

  @override
  State<AgencyProfile> createState() => _AgencyProfileState();
}

class _AgencyProfileState extends State<AgencyProfile> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    double sW = MediaQuery.of(context).size.width;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          print('Logout success state received');
          Navigator.pushNamedAndRemoveUntil(
              context, '/login_ui', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor("#1E9CFF"),
          title: Text(
            "Messages",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  FutureBuilder<String?>(
                    future: ProfileUserStorage.getUserEmail(),
                    builder: (context, emailSnapshot) {
                      if (emailSnapshot.connectionState == ConnectionState.done) {
                        String? email = emailSnapshot.data;
                        return FutureBuilder<String?>(
                          future: ProfileUserStorage.getProfileImage(email!),
                          builder: (context, snapshot) {
                            return imageProfile(snapshot);
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                  FutureBuilder<String?>(
                    future: ProfileAgencyStorage.getAgencyName(),
                    builder: (context, nameSnapshot) {
                      if (nameSnapshot.connectionState == ConnectionState.done) {
                        String? agencyName = nameSnapshot.data;
                        return Padding(
                          padding: EdgeInsets.only(left: sW * 0.05),
                          child: Text(
                            agencyName ?? "Default Name",
                            style: GoogleFonts.afacad(
                              textStyle: TextStyle(fontSize: sW * 0.06),
                            ),
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    profileOptionCard(
                      "General Information",
                      onTap: () async {
                        String email = await ProfileUserStorage.getUserEmail() ?? '';
                        String token = await TokenStorage.getToken() ?? '';
                        bool? shouldRefresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GeneralInformationPage(
                              email: email,
                              token: token,
                            ),
                          ),
                        );
                        if (shouldRefresh == true) {
                          refreshProfile();
                        }
                      },
                    ),
                    profileOptionCard(
                      "Offers and Promotions",
                      onTap: () {
                        Navigator.pushNamed(context, '/offers_promotions');
                      },
                    ),
                    profileOptionCard(
                      "Settings",
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                    profileOptionCard(
                      "Uploaded Places",
                      onTap: () async {
                        String agencyId = await ProfileAgencyStorage.getAgencyId() ?? '';
                        String userToken = await TokenStorage.getToken() ?? '';
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgencyPlacesPage(
                              agencyId: agencyId,
                              userToken: userToken,
                            ),
                          ),
                        );
                      },
                    ),
                    profileOptionCard(
                      "Log Out",
                      color: HexColor("#ff5c33"),
                      onTap: () {
                        context.read<LoginBloc>().add(LogoutEvent());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget profileOptionCard(String title, {Color? color, void Function()? onTap}) {
    return Card(
      margin: EdgeInsets.all(15),
      color: color ?? Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  Widget BottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text("Choose a Profile photo", style: TextStyle(fontSize: 20.0)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera"),
              ),
              TextButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget imageProfile(AsyncSnapshot<String?> snapshot) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 60.0,
          backgroundImage: snapshot.data != null
              ? FileImage(File(snapshot.data!)) as ImageProvider<Object>?
              : AssetImage('assets/agencyImages/avatar.png'),
        ),
        Positioned(
          bottom: 1.0,
          right: 30.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: ((builder) => BottomSheet()),
              );
            },
            child: Icon(Icons.camera_alt, color: Colors.teal, size: 28.0),
          ),
        ),
      ],
    );
  }

  void takePhoto(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
      String? token = await TokenStorage.getToken();
      String? email = await ProfileAgencyStorage.getAgencyEmail();
      if (token != null && email != null) {
        await uploadProfilePhoto(File(pickedFile.path), token, email);
      } else {
        print('token or email is null: $token, $email');
      }
    }
  }

  Future<void> uploadProfilePhoto(File imageFile, String token, String email) async {
    await ProfileUserStorage.deleteProfileImage(email);
    await ProfileUserStorage.storeProfileImage(email, imageFile.path);
    context.read<ProfileBloc>().add(
          UploadProfileImage(imageFile: imageFile, token: token, email: email),
        );
  }

  void refreshProfile() {
    setState(() {});
  }
}
