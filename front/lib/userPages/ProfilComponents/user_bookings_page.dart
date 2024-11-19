// lib/userPages/ProfilComponents/user_bookings_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_bloc.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_event.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_state.dart';
import 'package:tataguid/models/booking.dart';
import 'package:tataguid/repository/get_places_repository.dart';
import 'package:tataguid/userPages/TourPages.dart';

class UserBookingsPage extends StatefulWidget {
  @override
  _UserBookingsPageState createState() => _UserBookingsPageState();
}

class _UserBookingsPageState extends State<UserBookingsPage> {
  final PlaceRepository placeRepository = PlaceRepository();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BookingBloc>(context).add(FetchUserBookings());
  }

  void _cancelBooking(String? bookingId) {
    if (bookingId != null) {
      BlocProvider.of<BookingBloc>(context).add(DeleteBooking(bookingId));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking ID is null and cannot be cancelled")),
      );
    }
  }

  Future<void> _viewPlaceDetails(String placeId) async {
    try {
      final place = await placeRepository.fetchPlaceById(placeId); // Fetch place details
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TourPage(
            place: place, // Pass the fetched place
            showBookingButton: false, // Hide the booking button
          ),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load place details: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Bookings",
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BookingError) {
            return Center(child: Text(state.message));
          } else if (state is BookingsLoaded) {
            final bookings = state.bookings;
            if (bookings.isEmpty) {
              return Center(child: Text("No bookings found"));
            }
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.book_online, color: Colors.teal, size: 40),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Booking #${index + 1}",
                                    style: GoogleFonts.lato(
                                      fontSize: screenWidth * 0.05,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Place: ${booking.placeName}",
                                    style: GoogleFonts.lato(fontSize: screenWidth * 0.045),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "titel: ${booking.title}",
                                    style: GoogleFonts.lato(fontSize: screenWidth * 0.045),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Date: ${booking.bookingDate}",
                                    style: GoogleFonts.lato(fontSize: screenWidth * 0.045),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () => _viewPlaceDetails(booking.placeId!),
                              child: Text('View Details'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () => _cancelBooking(booking.id),
                              child: Text("Cancel"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Text("Something went wrong"));
        },
      ),
    );
  }
}
