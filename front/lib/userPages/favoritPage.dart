// lib/userPages/favoritesPage.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/favorite/favorite_bloc.dart';
import 'package:tataguid/blocs/favorite/favorite_event.dart';
import 'package:tataguid/blocs/favorite/favorite_state.dart';
import 'package:tataguid/repository/favorites_repository.dart';
import 'package:tataguid/userPages/TourPages.dart';

class FavoritesPage extends StatelessWidget {
  final String userId;

  FavoritesPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteBloc(favoritesRepository: FavoritesRepository())
        ..add(FetchFavorites(userId: userId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
          backgroundColor: Colors.deepPurple,
        ),
        body: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FavoriteError) {
              return Center(child: Text('Failed to load favorites: ${state.message}'));
            } else if (state is FavoriteLoaded) {
              if (state.favoritePlaces.isEmpty) {
                return Center(child: Text('No favorites found'));
              }
              return ListView.builder(
                itemCount: state.favoritePlaces.length,
                itemBuilder: (context, index) {
                  final place = state.favoritePlaces[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListTile(
                      title: Text(place.title ?? 'No Title'),
                      subtitle: Text(place.placeName ?? 'No Place Name'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TourPage(
                              place: place,
                              showBookingButton: true,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
