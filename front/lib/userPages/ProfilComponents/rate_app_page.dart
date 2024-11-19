// lib/userPages/rate_app_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RateAppPage extends StatefulWidget {
  @override
  _RateAppPageState createState() => _RateAppPageState();
}

class _RateAppPageState extends State<RateAppPage> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Rate the App", style: GoogleFonts.lato()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "How would you rate our app?",
              style: GoogleFonts.lato(fontSize: screenWidth * 0.05),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    _rating > index ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  iconSize: screenWidth * 0.1,
                );
              }),
            ),
            SizedBox(height: 20),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Leave your feedback here",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle rating submission
              },
              child: Text("Submit", style: GoogleFonts.lato(fontSize: screenWidth * 0.05)),
            ),
          ],
        ),
      ),
    );
  }
}
