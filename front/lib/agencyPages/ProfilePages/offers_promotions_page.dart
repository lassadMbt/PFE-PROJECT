// lib/agencyPages/offers_promotions_page.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class OffersPromotionsPage extends StatelessWidget {
  const OffersPromotionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#1E9CFF"),
        title: Text(
          "Offers and Promotions",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Offers",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.045),
              ),
              SizedBox(height: screenHeight * 0.02),
              // Example offer card
              offerCard(
                screenWidth,
                screenHeight,
                title: "Summer Special",
                description:
                    "Enjoy a 20% discount on all our summer holiday packages!",
                validity: "Valid until 30th June",
              ),
              offerCard(
                screenWidth,
                screenHeight,
                title: "Early Bird Discount",
                description:
                    "Book your holiday package 3 months in advance and get a 15% discount.",
                validity: "Valid for the first 100 customers",
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Add New Offer",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: screenWidth * 0.045),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Offer Title",
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Offer Description",
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Validity",
                  filled: true,
                  fillColor: Colors.white60,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Save the offer
                  },
                  child: Text('Save Offer'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget offerCard(double screenWidth, double screenHeight,
      {required String title, required String description, required String validity}) {
    return Card(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.045)),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              description,
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(fontSize: screenWidth * 0.04)),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              validity,
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: screenWidth * 0.035)),
            ),
          ],
        ),
      ),
    );
  }
}
