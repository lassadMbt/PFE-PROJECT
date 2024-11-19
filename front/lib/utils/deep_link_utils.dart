// lib/utils/deep_link_utils.dart
import 'package:tataguid/models/place_model.dart';

String generateDeepLink(PlaceModel place) {
  // Using the custom URL scheme registered in AndroidManifest.xml
  return 'app://tataguid.com/places/${place.id}';
}