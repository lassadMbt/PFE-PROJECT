// frontend/lib/blocs/guest/guest_state.dart

// guest_state.dart

import 'package:equatable/equatable.dart';

abstract class GuestState extends Equatable {
  const GuestState();

  @override
  List<Object> get props => [];
}

class GuestInitial extends GuestState {}

class GuestLoading extends GuestState {}

class GuestLoaded extends GuestState {
  final String guestID;
  final bool isGuest; // Add this flag

  const GuestLoaded(this.guestID, {this.isGuest = true});

  @override
  List<Object> get props => [guestID, isGuest];
}

class GuestError extends GuestState {
  final String message;

  const GuestError(this.message);

  @override
  List<Object> get props => [message];
}
