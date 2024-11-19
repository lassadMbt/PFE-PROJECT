// lib/blocs/uploadBloc/upload_event.dart

import 'package:equatable/equatable.dart';
import 'package:tataguid/models/upload.model.dart'; // Import the UploadModel class

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

// Define events related to uploading
class UploadData extends UploadEvent {
  final String agencyId;
  final String token;
  final UploadModel uploadModel; // Use UploadModel as the data model

  const UploadData({
    required this.agencyId,
    required this.token,
    required this.uploadModel,
  });

  @override
  List<Object> get props => [agencyId, token, uploadModel];
}
