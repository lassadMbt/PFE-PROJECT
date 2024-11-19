// lib/agencyPages/settings_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#1E9CFF"),
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            settingsOptionCard(
              screenWidth,
              title: "Change Password",
              onTap: () {
                // Navigate to change password page
              },
            ),
            settingsOptionCard(
              screenWidth,
              title: "Notification Settings",
              onTap: () {
                // Navigate to notification settings page
              },
            ),
            settingsOptionCard(
              screenWidth,
              title: "Privacy Policy",
              onTap: () {
                // Navigate to privacy policy page
              },
            ),
            settingsOptionCard(
              screenWidth,
              title: "Terms of Service",
              onTap: () {
                // Navigate to terms of service page
              },
            ),
            settingsOptionCard(
              screenWidth,
              title: "Help & Support",
              onTap: () {
                // Navigate to help and support page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsOptionCard(double screenWidth,
      {required String title, required void Function()? onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: screenWidth * 0.045,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
