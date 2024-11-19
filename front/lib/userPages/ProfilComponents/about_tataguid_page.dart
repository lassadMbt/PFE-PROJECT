// lib/userPages/about_tataguid_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutTataGuidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("About TataGuid", style: GoogleFonts.lato()),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About TataGuid",
              style: GoogleFonts.lato(fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "TataGuid is a comprehensive guide app designed to provide users with a seamless experience. "
              "Our mission is to offer reliable and user-friendly services to make your life easier. "
              "Whether you're looking for information, booking services, or just exploring, TataGuid is here to help.",
              style: GoogleFonts.lato(fontSize: screenWidth * 0.05),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle contact us
                  },
                  icon: Icon(Icons.email),
                  label: Text("Contact Us", style: GoogleFonts.lato(fontSize: screenWidth * 0.05)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
