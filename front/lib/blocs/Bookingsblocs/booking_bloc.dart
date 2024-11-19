// lib/blocs/booking/booking_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_event.dart';
import 'package:tataguid/blocs/Bookingsblocs/booking_state.dart';
import 'package:tataguid/models/booking.dart';
import 'package:tataguid/models/place_model.dart';
import 'package:tataguid/repository/booking_repository.dart';
import 'package:tataguid/storage/token_storage.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final BookingRepository bookingRepository;

  BookingBloc({required this.bookingRepository}) : super(BookingInitial()) {
    on<FetchBookings>(_onFetchBookings);
    on<FetchUserBookings>(_onFetchUserBookings);
    on<AddBooking>(_onAddBooking);
    on<UpdateBooking>(_onUpdateBooking);
    on<DeleteBooking>(_onDeleteBooking);
    on<FetchAgencyBookings>(_onFetchAgencyBookings);
  }

 void _onFetchAgencyBookings(FetchAgencyBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await bookingRepository.fetchAgencyBookings(event.agencyId);
      emit(BookingsLoaded(bookings));
    } catch (error) {
      emit(BookingError('Failed to load agency bookings: $error'));
    }
  }


  void _onFetchBookings(FetchBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await bookingRepository.fetchBookings();
      emit(BookingsLoaded(bookings));
    } catch (error) {
      emit(BookingError('Failed to load bookings: $error'));
    }
  }

  void _onFetchUserBookings(
      FetchUserBookings event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final bookings = await bookingRepository.fetchUserBookings();
      emit(BookingsLoaded(bookings));
    } catch (error) {
      emit(BookingError('Failed to load user bookings: $error'));
    }
  }
void _onAddBooking(AddBooking event, Emitter<BookingState> emit) async {
  emit(BookingLoading());
  try {
    final userId = await TokenStorage.getAgencyId();
    if (userId == null) {
      emit(BookingError('User ID is null'));
      return;
    }

    final placeId = event.booking.placeId;
    if (placeId == null) {
      emit(BookingError('Place ID is null'));
      return;
    }

    final PlaceModel place = await bookingRepository.fetchPlace(placeId);
    final newBooking = await bookingRepository.addBooking(event.booking, userId, place);
    emit(BookingAdded(newBooking));
  } catch (error) {
    emit(BookingError('Failed to add booking: $error'));
  }
}


  void _onUpdateBooking(
      UpdateBooking event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    try {
      final updatedBooking = await bookingRepository.updateBooking(event.booking);
      emit(BookingUpdated(updatedBooking));
    } catch (error) {
      emit(BookingError('Failed to update booking: $error'));
    }
  }

 void _onDeleteBooking(
  DeleteBooking event, Emitter<BookingState> emit) async {
  emit(BookingLoading());
  try {
    // Delete the booking
    await bookingRepository.deleteBooking(event.bookingId);

    // Fetch the updated list of bookings
    String? agencyId = await TokenStorage.getAgencyId();
    if (agencyId != null) {
      List<BookingModel> updatedBookings = await bookingRepository.fetchAgencyBookings(agencyId);
      emit(BookingsLoaded(updatedBookings));
    } else {
      emit(BookingError('Agency ID not found'));
    }
  } catch (error) {
    emit(BookingError('Failed to delete booking: $error'));
  }
}
}
