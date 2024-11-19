// lib/userPages/MapPage.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MapPage extends StatefulWidget {
  final String? placeName;

  const MapPage({super.key, this.placeName});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = Location();
  LatLng? _currentPosition;
  LatLng? _selectedDestination;
  GoogleMapController? _mapController;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final String _googleApiKey = 'PUT YOUR API KEY HERE';

  List<dynamic> _suggestions = [];
  Set<Marker> _markers = {};
  List<LatLng> _polylineCoordinates = [];
  Polyline? _routePolyline;
  Timer? _debounce;
  MapType _currentMapType = MapType.normal;

  bool _showNearbyButtons = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _searchController.addListener(_onSearchChanged);

    if (widget.placeName != null && widget.placeName!.isNotEmpty) {
      print('Searching for place: ${widget.placeName}');
      _searchPlacesByName(widget.placeName!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.isNotEmpty) {
        _fetchSuggestions(_searchController.text);
      } else {
        setState(() {
          _suggestions = [];
        });
      }
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'OK') {
          setState(() {
            _suggestions = json['predictions'];
          });
        } else {
          print('Error status: ${json['status']}');
          print('Error message: ${json['error_message']}');
        }
      } else {
        print('Failed to load suggestions: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _searchPlacesByName(String placeName) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$placeName&inputtype=textquery&fields=geometry,name&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'OK' && json['candidates'].isNotEmpty) {
          final place = json['candidates'][0];
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];

          final newPosition = LatLng(lat, lng);

          setState(() {
            _selectedDestination = newPosition;
            _markers.add(
              Marker(
                markerId: MarkerId("destination"),
                position: newPosition,
                infoWindow: InfoWindow(
                  title: place['name'],
                  snippet: 'Place',
                ),
              ),
            );
          });

          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(newPosition, 15),
          );
        } else {
          print('No results found or API error: ${json['status']}');
        }
      } else {
        print('Failed to load place details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _getDirections(LatLng origin, LatLng destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude}&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'OK') {
          final points = json['routes'][0]['overview_polyline']['points'];
          _polylineCoordinates = _decodePolyline(points);

          setState(() {
            _routePolyline = Polyline(
              polylineId: PolylineId('route'),
              points: _polylineCoordinates,
              color: Colors.blue,
              width: 5,
            );
          });
        } else {
          print('Error in directions API: ${json['status']}');
        }
      } else {
        print('Failed to fetch directions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<LatLng> _decodePolyline(String poly) {
    List<LatLng> points = [];
    int index = 0, len = poly.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = poly.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _clearMarkers() {
    setState(() {
      _markers.clear();
      _routePolyline = null;
    });
  }

  void _toggleMapType() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  Future<void> _searchNearby(String type) async {
    if (_currentPosition == null) return;

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${_currentPosition!.latitude},${_currentPosition!.longitude}&radius=1500&type=$type&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'OK') {
          setState(() {
            _markers.clear();
            for (var result in json['results']) {
              final marker = Marker(
                markerId: MarkerId(result['place_id']),
                position: LatLng(
                  result['geometry']['location']['lat'],
                  result['geometry']['location']['lng'],
                ),
                infoWindow: InfoWindow(
                  title: result['name'],
                  snippet: result['vicinity'],
                ),
              );
              _markers.add(marker);
            }
          });
        } else {
          print('Error status: ${json['status']}');
        }
      } else {
        print('Failed to load nearby places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.77483, -122.41942),
              zoom: 12,
            ),
            markers: _markers,
            polylines: _routePolyline != null ? Set.of([_routePolyline!]) : {},
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _getCurrentLocation();
            },
          ),
          Positioned(
            top: 10,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.0,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search places',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          if (_suggestions.isNotEmpty) {
                            _searchPlaces(_suggestions.first['place_id']);
                          }
                        },
                      ),
                    ),
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_suggestions[index]['description']),
                          onTap: () {
                            _searchPlaces(_suggestions[index]['place_id']);
                            setState(() {
                              _suggestions = [];
                            });
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 15,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _showNearbyButtons = !_showNearbyButtons;
                    });
                  },
                  child: Icon(Icons.menu),
                ),
                SizedBox(height: 75),
                Visibility(
                  visible: _showNearbyButtons,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: _drawRoute,
                        child: Icon(Icons.directions),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: _clearMarkers,
                        child: Icon(Icons.clear),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: _toggleMapType,
                        child: Icon(Icons.map),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: () => _searchNearby('restaurant'),
                        child: Icon(Icons.restaurant),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: () => _searchNearby('gas_station'),
                        child: Icon(Icons.local_gas_station),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      final location = await _locationController.getLocation();
      final currentPosition = LatLng(location.latitude!, location.longitude!);

      setState(() {
        _currentPosition = currentPosition;
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: currentPosition,
            infoWindow: InfoWindow(
              title: 'Current Location',
            ),
          ),
        );
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentPosition, 15),
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus permissionGranted = await _locationController.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      bool serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        print('Location services are disabled.');
      }
    }
  }

  Future<void> _searchPlaces(String placeId) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$_googleApiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == 'OK') {
          final place = json['result'];
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];

          final newPosition = LatLng(lat, lng);

          setState(() {
            _selectedDestination = newPosition;
            _markers.clear();
            _markers.add(
              Marker(
                markerId: MarkerId("destination"),
                position: newPosition,
                infoWindow: InfoWindow(
                  title: place['name'],
                  snippet: 'Place',
                ),
              ),
            );
          });

          _mapController?.animateCamera(
            CameraUpdate.newLatLngZoom(newPosition, 15),
          );

          if (_currentPosition != null) {
            _getDirections(_currentPosition!, newPosition);
          }
        } else {
          print('No results found or API error: ${json['status']}');
        }
      } else {
        print('Failed to load place details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _drawRoute() async {
    if (_currentPosition != null && _selectedDestination != null) {
      _getDirections(_currentPosition!, _selectedDestination!);
    } else {
      print('Current location or destination is not set.');
    }
  }
}
