  // lib/blocs/uploadBloc/upload_state.dart

  import 'package:equatable/equatable.dart';

  abstract class UploadState extends Equatable {
    const UploadState();

    @override
    List<Object> get props => [];
  }

  // Define states for upload process
  class UploadInitial extends UploadState {}

  class UploadInProgress extends UploadState {}

  class UploadSuccess extends UploadState {}

  class UploadFailure extends UploadState {
    final String error;

    const UploadFailure({required this.error});

    @override
    List<Object> get props => [error];
  }
