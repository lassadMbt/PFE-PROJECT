// lib/blocs/favorite/favorite_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/repository/favorites_repository.dart';
import 'favorite_event.dart';
import 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoritesRepository favoritesRepository;

  FavoriteBloc({required this.favoritesRepository}) : super(FavoriteInitial()) {
    on<AddFavorite>(_onAddFavorite);
    on<FetchFavorites>(_onFetchFavorites);
  }

  void _onAddFavorite(AddFavorite event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      await favoritesRepository.addFavorite(event.userId, event.placeId);
      final favoritePlaces =
          await favoritesRepository.getFavorites(event.userId);
      emit(FavoriteLoaded(favoritePlaces: favoritePlaces));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  void _onFetchFavorites(
      FetchFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final favoritePlaces =
          await favoritesRepository.getFavorites(event.userId);
      emit(FavoriteLoaded(favoritePlaces: favoritePlaces));
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }
}
