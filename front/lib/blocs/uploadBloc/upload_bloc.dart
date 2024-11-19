// lib/blocs/uploadBloc/upload_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tataguid/blocs/uploadBloc/upload_event.dart';
import 'package:tataguid/blocs/uploadBloc/upload_state.dart';
import 'package:tataguid/repository/upload_repository.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final UploadRepository uploadRepository;

  UploadBloc({required this.uploadRepository}) : super(UploadInitial()) {
    on<UploadData>(_onUploadDataToUser);
  }

  void _onUploadDataToUser(UploadData event, Emitter<UploadState> emit) async {
    try {
      emit(UploadInProgress());
      // Convert UploadModel to JSON
      final Map<String, dynamic> jsonData = event.uploadModel.toJson();
      // Log the data being sent
      print('Sending data to add place: $jsonData');
      // Call the repository method to add a new place
      await UploadRepository.addPlace(
        event.agencyId, // Pass agency ID here
        jsonData, // Pass data map here
        event.token, // Pass token here
      );

      emit(UploadSuccess());
    } catch (e) {
      emit(UploadFailure(error: 'Failed to upload: $e'));
    }
  }
}
