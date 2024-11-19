// lib/agencyPages/ProfilePages/place_detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/getPlace/get_place_bloc.dart';
import 'package:tataguid/blocs/getPlace/get_place_event.dart';
import 'package:tataguid/blocs/getPlace/get_place_state.dart';
import 'package:tataguid/models/place_model.dart';
import 'package:tataguid/repository/get_places_repository.dart';

class PlaceDetailPage extends StatelessWidget {
  final String placeId;

  const PlaceDetailPage({Key? key, required this.placeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaceBloc(placeRepository: PlaceRepository())
        ..add(FetchPlaceById(placeId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Place Details'),
        ),
        body: BlocBuilder<PlaceBloc, PlaceState>(
          builder: (context, state) {
            if (state is PlaceLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PlaceLoaded) {
              PlaceModel place = state.places.first;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Title: ${place.title}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text('Place Name: ${place.placeName}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8.0),
                      Text('Description: ${place.description}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8.0),
                      Text('Price: ${place.price}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8.0),
                      Text('Images:', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8.0),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: place.photos.length,
                        itemBuilder: (context, index) {
                          return Image.network(place.photos[index]);
                        },
                      ),
                      SizedBox(height: 8.0),
                    ],
                  ),
                ),
              );
            } else if (state is PlaceError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Place not found.'));
            }
          },
        ),
      ),
    );
  }
}
