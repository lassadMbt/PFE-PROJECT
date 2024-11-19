// lib/agencyPages/agency_places_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/agencyPages/ProfilePages/place_detail_page.dart';
import 'package:tataguid/blocs/getPlace/get_place_bloc.dart';
import 'package:tataguid/blocs/getPlace/get_place_event.dart';
import 'package:tataguid/blocs/getPlace/get_place_state.dart';
import 'package:tataguid/models/place_model.dart';
import 'package:tataguid/repository/get_places_repository.dart';

class AgencyPlacesPage extends StatefulWidget {
  final String agencyId;
  final String userToken;

  const AgencyPlacesPage({Key? key, required this.agencyId, required this.userToken}) : super(key: key);

  @override
  _AgencyPlacesPageState createState() => _AgencyPlacesPageState();
}

class _AgencyPlacesPageState extends State<AgencyPlacesPage> {
  TextEditingController _searchController = TextEditingController();
  List<PlaceModel> _allPlaces = [];
  List<PlaceModel> _filteredPlaces = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _filteredPlaces = _allPlaces
          .where((place) =>
              place.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              place.placeName.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaceBloc(placeRepository: PlaceRepository())
        ..add(FetchPlaces(widget.agencyId, widget.userToken)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Uploaded Places', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.deepPurple,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<PlaceBloc, PlaceState>(
                  builder: (context, state) {
                    if (state is PlaceLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is PlaceLoaded) {
                      _allPlaces = state.places;
                      _filteredPlaces = _searchController.text.isEmpty
                          ? _allPlaces
                          : _allPlaces
                              .where((place) =>
                                  place.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                                  place.placeName.toLowerCase().contains(_searchController.text.toLowerCase()))
                              .toList();

                      return _filteredPlaces.isEmpty
                          ? Center(child: Text('No places found.'))
                          : ListView.builder(
                              itemCount: _filteredPlaces.length,
                              itemBuilder: (context, index) {
                                PlaceModel place = _filteredPlaces[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  elevation: 4.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(16.0),
                                    title: Text(
                                      place.title,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(place.placeName),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            BlocProvider.of<PlaceBloc>(context).add(DeletePlace(place.id, widget.userToken));
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.info, color: Colors.blue),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PlaceDetailPage(placeId: place.id),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                    } else if (state is PlaceError) {
                      return Center(child: Text(state.message));
                    } else {
                      return Center(child: Text('No places found.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceSearch extends SearchDelegate<PlaceModel> {
  final List<PlaceModel> places;

  PlaceSearch(this.places);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(
        context,
        PlaceModel(
          id: '',
          title: '',
          placeName: '',
          startEndPoint: '',
          photos: [],
          visitDate: '',
          price: 0.0,
          description: '',
          duration: '',
          hotelName: '',
          checkInOut: '',
          accessibility: '',
          tags: [],
          phoneNumber: '',
          agencyName: '',
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = places
        .where((place) =>
            place.title.toLowerCase().contains(query.toLowerCase()) ||
            place.placeName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        PlaceModel place = results[index];
        return ListTile(
          title: Text(place.title),
          subtitle: Text(place.placeName),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlaceDetailPage(placeId: place.id),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = places
        .where((place) =>
            place.title.toLowerCase().contains(query.toLowerCase()) ||
            place.placeName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        PlaceModel place = suggestions[index];
        return ListTile(
          title: Text(place.title),
          subtitle: Text(place.placeName),
          onTap: () {
            query = place.title;
            showResults(context);
          },
        );
      },
    );
  }
}
