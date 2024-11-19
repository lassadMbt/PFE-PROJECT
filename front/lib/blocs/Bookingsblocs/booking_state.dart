// lib/blocs/booking/booking_state.dart

import 'package:equatable/equatable.dart';
import 'package:tataguid/models/booking.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingsLoaded extends BookingState {
  final List<BookingModel> bookings;

  const BookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingAdded extends BookingState {
  final BookingModel booking;

  const BookingAdded(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingUpdated extends BookingState {
  final BookingModel booking;

  const BookingUpdated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingDeleted extends BookingState {
  final String bookingId;

  const BookingDeleted(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}
