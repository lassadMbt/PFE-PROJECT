// lib/agencyPages/homePage.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_bloc.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_event.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_state.dart';
import 'package:tataguid/models/booking.dart';
import 'package:tataguid/storage/token_storage.dart';
import 'package:tataguid/storage/profil_storage.dart';

class AgencyHome extends StatefulWidget {
  const AgencyHome({super.key});

  @override
  State<AgencyHome> createState() => _AgencyHomeState();
}

class _AgencyHomeState extends State<AgencyHome> {
  final userName = ProfileUserStorage.getUserName();
  final userEmail = ProfileUserStorage.getUserEmail();

  @override
  void initState() {
    super.initState();
    _fetchAgencyBookings();
  }

  void _fetchAgencyBookings() async {
    String? agencyId = await TokenStorage.getAgencyId();
    if (agencyId != null) {
      BlocProvider.of<BookingBloc>(context).add(FetchAgencyBookings(agencyId));
    }
  }

  Future<void> _refreshBookings() async {
    _fetchAgencyBookings();
  }

  Future<String?> _getProfileImage(String? email) async {
    if (email == null) return null;
    String? imagePath = await ProfileUserStorage.getProfileImage(email);
    if (imagePath != null && imagePath.startsWith('/')) {
      // This is a local file path
      return imagePath;
    }
    // This is a network URL or null
    return imagePath;
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 25,
                ),
                title: Container(
                  width: double.infinity,
                  height: 16.0,
                  color: Colors.white,
                ),
                subtitle: Column(
                  children: [
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 14.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _deleteBooking(String bookingId) {
    BlocProvider.of<BookingBloc>(context).add(DeleteBooking(bookingId));
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [HexColor("#1E9CFF"), HexColor("#1E50FF")],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Handle menu button press
          },
        ),
        title: Text(
          "Bookings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // Handle profile button press
            },
          ),
        ],
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return _buildShimmer();
          } else if (state is BookingError) {
            return Center(child: Text(state.message));
          } else if (state is BookingsLoaded) {
            if (state.bookings.isEmpty) {
              return Center(child: Text('No bookings available'));
            } else {
              return RefreshIndicator(
                onRefresh: _refreshBookings,
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: ListView.builder(
                          itemCount: state.bookings.length,
                          itemBuilder: (context, index) {
                            final booking = state.bookings[index];
                            return FutureBuilder<String?>(
                              future: _getProfileImage(booking.userEmail),
                              builder: (context, snapshot) {
                                String? profileImage = snapshot.data;
                                ImageProvider imageProvider;
                                if (profileImage != null && profileImage.startsWith('/')) {
                                  // Local file path
                                  imageProvider = FileImage(File(profileImage));
                                } else if (profileImage != null && profileImage.startsWith('http')) {
                                  // Network image
                                  imageProvider = NetworkImage(profileImage);
                                } else {
                                  // Default asset image
                                  imageProvider = AssetImage("assets/Profileimage.png");
                                }

                                return Dismissible(
                                  key: Key(booking.id ?? index.toString()),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    color: Colors.red,
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (direction) {
                                    _deleteBooking(booking.id!);
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(color: HexColor("#1E9CFF"), width: 2),
                                    ),
                                    elevation: 5,
                                    child: ExpansionTile(
                                      backgroundColor: Colors.white,
                                      collapsedBackgroundColor: Colors.white,
                                      tilePadding: EdgeInsets.all(10),
                                      title: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: imageProvider,
                                            radius: 25,
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  booking.userName ?? booking.userEmail ?? "",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  booking.userEmail ?? "",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  booking.placeName ?? "",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                Text(
                                                  booking.bookingDate?.toString() ?? "",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(20),
                                          color: Colors.grey[100],
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                booking.title ?? "",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                booking.price != null
                                                    ? '\$${booking.price!.toStringAsFixed(2)}'
                                                    : 'Price not available',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Text(
                                                booking.notes ?? "",
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Center(child: Text('No bookings available'));
          }
        },
      ),
    );
  }
}
