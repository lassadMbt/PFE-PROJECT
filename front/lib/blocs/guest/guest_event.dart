// frontend/lib/blocs/guest/guest_event.dart

import 'package:equatable/equatable.dart';

abstract class GuestEvent extends Equatable {
  const GuestEvent();

  @override
  List<Object> get props => [];
}

class GenerateGuestID extends GuestEvent {}

