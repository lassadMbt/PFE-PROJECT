// lib/userPages/PlaceSearchDelegate.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tataguid/models/place_model.dart';
import 'package:tataguid/userPages/TourPages.dart';

class PlaceSearchDelegate extends SearchDelegate {
  final List<PlaceModel> places;
  final Set<String> favorites;
  final Function(PlaceModel) onFavoriteToggle;

  PlaceSearchDelegate({required this.places, required this.favorites, required this.onFavoriteToggle});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredPlaces = places
        .where((place) =>
            place.title.toLowerCase().contains(query.toLowerCase()) ||
            place.placeName.toLowerCase().contains(query.toLowerCase()) ||
            place.price.toString().contains(query) ||
            place.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())))
        .toList();

    if (filteredPlaces.isEmpty) {
      return Center(
        child: Text(
          'No results found for "$query"',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredPlaces.length,
      itemBuilder: (context, index) {
        final place = filteredPlaces[index];
        final isFavorite = favorites.contains(place.id);

        return GestureDetector(
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
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: _buildImage(
                        place.photos.isNotEmpty
                            ? place.photos.first
                            : 'https://via.placeholder.com/400x200',
                        double.infinity, // width
                        150, // height
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.white,
                        ),
                        onPressed: () {
                          onFavoriteToggle(place);
                        },
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.title ?? 'No Title',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        place.placeName ?? 'No Place Name',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: place.tags
                            .map((tag) => Chip(
                                  label: Text(tag),
                                  backgroundColor: Colors.deepPurple.shade100,
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.grey[700]),
                          SizedBox(width: 4),
                          Text(
                            place.duration ?? 'No Duration',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.monetization_on, size: 16, color: Colors.grey[700]),
                          SizedBox(width: 4),
                          Text(
                            '\$${place.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
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
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  Widget _buildImage(String url, double width, double height) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      );
    } else {
      return Image.file(
        File(url),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      );
    }
  }
}

