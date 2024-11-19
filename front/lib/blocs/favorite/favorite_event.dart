// lib/blocs/favorite/favorite_event.dart

import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class AddFavorite extends FavoriteEvent {
  final String userId;
  final String placeId;

  AddFavorite({required this.userId, required this.placeId});

  @override
  List<Object> get props => [userId, placeId];
}

class FetchFavorites extends FavoriteEvent {
  final String userId;

  FetchFavorites({required this.userId});

  @override
  List<Object> get props => [userId];
}
