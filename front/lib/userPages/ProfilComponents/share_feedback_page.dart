// lib/userPages/share_feedback_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareFeedbackPage extends StatefulWidget {
  @override
  _ShareFeedbackPageState createState() => _ShareFeedbackPageState();
}

class _ShareFeedbackPageState extends State<ShareFeedbackPage> {
  final TextEditingController feedbackController = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    feedbackController.addListener(() {
      setState(() {
        _charCount = feedbackController.text.length;
      });
    });
  }

  void _submitFeedback() {
    if (feedbackController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Thank you!", style: GoogleFonts.lato()),
          content: Text("Your feedback has been submitted.", style: GoogleFonts.lato()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK", style: GoogleFonts.lato()),
            ),
          ],
        ),
      );
      feedbackController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Share Feedback", style: GoogleFonts.lato()),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: feedbackController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: "Enter your feedback here",
                border: OutlineInputBorder(),
                counterText: '$_charCount/500',
              ),
              maxLength: 500,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitFeedback,
              child: Text("Submit", style: GoogleFonts.lato(fontSize: screenWidth * 0.05)),
            ),
          ],
        ),
      ),
    );
  }
}
