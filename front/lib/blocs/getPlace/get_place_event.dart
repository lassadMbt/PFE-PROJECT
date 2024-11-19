// lib/blocs/place/place_event.dart

import 'package:equatable/equatable.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();

  @override
  List<Object> get props => [];
}

class FetchPlaces extends PlaceEvent {
  final String agencyId;
  final String userToken;

  const FetchPlaces(this.agencyId, this.userToken);

  @override
  List<Object> get props => [agencyId, userToken];
}

class DeletePlace extends PlaceEvent {
  final String placeId;
  final String userToken;

  const DeletePlace(this.placeId, this.userToken);

  @override
  List<Object> get props => [placeId, userToken];
}

class FetchPlaceById extends PlaceEvent {
  final String placeId;

  const FetchPlaceById(this.placeId);

  @override
  List<Object> get props => [placeId];
}