// lib/userPages/profilePage.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tataguid/blocs/login/login_bloc.dart';
import 'package:tataguid/blocs/login/login_event.dart';
import 'package:tataguid/components/theme_manager.dart';
import 'package:tataguid/storage/profil_storage.dart';
import 'package:tataguid/userPages/ProfilComponents/about_tataguid_page.dart';
import 'package:tataguid/userPages/ProfilComponents/rate_app_page.dart';
import 'package:tataguid/userPages/ProfilComponents/share_feedback_page.dart';
import 'package:tataguid/userPages/ProfilComponents/user_bookings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showSettings = false;
  String theme = "Light";
  List<String> themes = ['Light', 'Dark'];
  String temperature = "°F";
  List<String> temperatures = ["°F", "°C"];
  String distance = "M";
  List<String> distances = ["M", "KM"];
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => BlocProvider.of<LoginBloc>(context),
      child: Scaffold(
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Profile & Settings",
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: screenWidth * 0.08,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
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
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      FutureBuilder<String?>(
                        future: ProfileUserStorage.getUserName(),
                        builder: (context, nameSnapshot) {
                          if (nameSnapshot.connectionState == ConnectionState.done) {
                            String? name = nameSnapshot.data;
                            return Padding(
                              padding: EdgeInsets.only(left: screenWidth * 0.05),
                              child: Text(
                                name ?? "Default Name",
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(fontSize: screenWidth * 0.06),
                                ),
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  buildSettingsTile(context, "Settings", Icons.settings, () {
                    setState(() {
                      showSettings = !showSettings;
                    });
                  }, showSettings),
                  if (showSettings) buildSettingsOptions(context, screenWidth),
                  buildDivider(),
                  buildProfileOption(context, "Restore Purchases", Icons.monetization_on_rounded, null),
                  buildDivider(),
                  buildProfileOption(context, "Rate the App", Icons.star_border_outlined, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RateAppPage()));
                  }),
                  buildDivider(),
                  buildProfileOption(context, "Share Feedback", Icons.message_outlined, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ShareFeedbackPage()));
                  }),
                  buildDivider(),
                  buildProfileOption(context, "About TataGuid", Icons.info_outline, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutTataGuidPage()));
                  }),
                  buildDivider(),
                  buildProfileOption(context, "Your Bookings", Icons.book_online, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserBookingsPage()));
                  }),
                  buildDivider(),
                  buildProfileOption(context, "Logout", Icons.logout, () {
                    context.read<LoginBloc>().add(LogoutEvent());
                    Navigator.of(context).pushReplacementNamed('/login_ui');
                  }),
                  buildDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSettingsTile(BuildContext context, String title, IconData icon, VoidCallback? onTap, bool showSettings) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon),
      title: Text(
        title,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing: Icon(showSettings ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
    );
  }

  Widget buildSettingsOptions(BuildContext context, double screenWidth) {
    return Container(
      margin: EdgeInsets.only(left: screenWidth * 0.1),
      child: Column(
        children: [
          buildSettingsOption("Application Theme", theme, themes, (newValue) {
            setState(() {
              theme = newValue!;
              if (theme == "Dark") {
                context.read<ThemeManager>().setTheme(ThemeMode.dark);
              } else {
                context.read<ThemeManager>().setTheme(ThemeMode.light);
              }
            });
          }),
          buildSettingsOption("Temperature", temperature, temperatures, (newValue) {
            setState(() {
              temperature = newValue!;
            });
          }),
          buildSettingsOption("Distance", distance, distances, (newValue) {
            setState(() {
              distance = newValue!;
            });
          }),
        ],
      ),
    );
  }

  Widget buildSettingsOption(String title, String currentValue, List<String> options, ValueChanged<String?> onChanged) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ListTile(
      title: Text(title),
      trailing: SizedBox(
        width: screenWidth * 0.3,
        child: DropdownButtonFormField<String>(
          value: currentValue,
          icon: const Icon(Icons.arrow_drop_down),
          menuMaxHeight: 200,
          items: options.map((String value) {
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList(),
          isDense: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget buildDivider() {
    return const Divider();
  }

  Widget buildProfileOption(BuildContext context, String title, IconData icon, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: onTap,
    );
  }

  Widget imageProfile(AsyncSnapshot<String?> snapshot) {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 50.0,
            backgroundImage: snapshot.hasData
                ? FileImage(File(snapshot.data!))
                : const AssetImage('assets/Profileimage.png') as ImageProvider,
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => buildBottomSheet()),
                );
              },
              child: const Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Choose a Profile Photo", style: TextStyle(fontSize: 20.0)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                icon: const Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: const Text("Camera"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: const Text("Gallery"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      // Save the new profile image path
      String? email = await ProfileUserStorage.getUserEmail();
      if (email != null) {
        await ProfileUserStorage.setProfileImage(email, _imageFile!.path);
      }
    }
  }
}
