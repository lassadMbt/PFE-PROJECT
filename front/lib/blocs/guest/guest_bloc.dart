// frontend/lib/blocs/guest/guest_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tataguid/repository/guest_repository.dart';
import './guest_event.dart';
import './guest_state.dart';

class GuestBloc extends Bloc<GuestEvent, GuestState> {
  final GuestRepository guestRepository;

  GuestBloc({required this.guestRepository}) : super(GuestInitial()) {
    on<GenerateGuestID>(_onGenerateGuestID); // Add this line to register the event handler
  }

  void _onGenerateGuestID(GenerateGuestID event, Emitter<GuestState> emit) async {
  emit(GuestLoading());
  try {
    final guestID = await guestRepository.generateGuestID();
    emit(GuestLoaded(guestID));
  } catch (e) {
    print('Error generating guest ID: $e'); // Add this line to print the error
    emit(GuestError('Failed to generate guest ID'));
  }
}
}
