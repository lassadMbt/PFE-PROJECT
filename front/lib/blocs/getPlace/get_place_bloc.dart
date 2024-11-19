  // lib/blocs/place/place_bloc.dart

  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:tataguid/blocs/getPlace/get_place_event.dart';
  import 'package:tataguid/blocs/getPlace/get_place_state.dart';
  import 'package:tataguid/models/place_model.dart';
  import 'package:tataguid/repository/get_places_repository.dart';

  class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
    final PlaceRepository placeRepository;

    PlaceBloc({required this.placeRepository}) : super(PlaceInitial()) {
      on<FetchPlaces>(_onFetchPlaces);
      on<DeletePlace>(_onDeletePlace);
      on<FetchPlaceById>(_onFetchPlaceById);
    }

    void _onFetchPlaces(FetchPlaces event, Emitter<PlaceState> emit) async {
      emit(PlaceLoading());
      try {
        final places = await placeRepository.getAllPlaces();
        emit(PlaceLoaded(places.cast<PlaceModel>()));
      } catch (error) {
        emit(PlaceError('Failed to load places: $error'));
      }
    }

    void _onDeletePlace(DeletePlace event, Emitter<PlaceState> emit) async {
      try {
        await placeRepository.deletePlaceById(event.placeId, event.userToken);
        // Re-fetch the places after deletion
        final places = await placeRepository.getAllPlaces();
        emit(PlaceLoaded(places.cast<PlaceModel>()));
      } catch (error) {
        emit(PlaceError('Failed to delete place: $error'));
      }
    }
    void _onFetchPlaceById(FetchPlaceById event, Emitter<PlaceState> emit) async {
      emit(PlaceLoading());
      try {
        final place = await placeRepository.fetchPlaceById(event.placeId);
        emit(PlaceLoaded([place]));
      } catch (error) {
        emit(PlaceError('Failed to load place details: $error'));
      }
    }
  }
