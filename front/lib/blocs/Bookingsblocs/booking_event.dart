// lib/blocs/booking/booking_event.dart

import 'package:equatable/equatable.dart';
import 'package:tataguid/models/booking.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class AddBooking extends BookingEvent {
  final BookingModel booking;

  const AddBooking(this.booking);

  @override
  List<Object?> get props => [booking];
}

class UpdateBooking extends BookingEvent {
  final BookingModel booking;

  const UpdateBooking(this.booking);

  @override
  List<Object?> get props => [booking];
}

class DeleteBooking extends BookingEvent {
  final String bookingId;

  const DeleteBooking(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

class FetchUserBookings extends BookingEvent {
  const FetchUserBookings();
}


class FetchBookings extends BookingEvent {
  final String agencyId;

  const FetchBookings(this.agencyId);

  @override
  List<Object?> get props => [agencyId];
}

class FetchAgencyBookings extends BookingEvent {
  final String agencyId;

  const FetchAgencyBookings(this.agencyId);

  @override
  List<Object?> get props => [agencyId];
}
