// lib/blocs/place/place_state.dart

import 'package:equatable/equatable.dart';
import 'package:tataguid/models/place_model.dart';
import 'package:tataguid/models/upload.model.dart';

abstract class PlaceState extends Equatable {
  const PlaceState();

  @override
  List<Object> get props => [];
}

class PlaceInitial extends PlaceState {}

class PlaceLoading extends PlaceState {}

class PlaceLoaded extends PlaceState {
  final List<PlaceModel> places;

  const PlaceLoaded(this.places);

  @override
  List<Object> get props => [places];
}

class PlaceError extends PlaceState {
  final String message;

  const PlaceError(this.message);

  @override
  List<Object> get props => [message];
}
