// lib/blocs/favorite/favorite_state.dart

import 'package:equatable/equatable.dart';
import 'package:tataguid/models/place_model.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<PlaceModel> favoritePlaces;

  FavoriteLoaded({required this.favoritePlaces});

  @override
  List<Object> get props => [favoritePlaces];
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}
