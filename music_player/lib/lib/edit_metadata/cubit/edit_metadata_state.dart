part of 'edit_metadata_cubit.dart';

enum EditMetadataStatus {
  initial,
  loading,
  editing,
  success,
  failure,
}

@immutable
class EditMetadataState extends Equatable {
  final String audioPath;
  final MediaMetadata? metadata;
  final EditMetadataStatus status;

  const EditMetadataState(
      {required this.audioPath, required this.metadata, this.status = EditMetadataStatus.initial});

  EditMetadataState copyWith({
    String? audioPath,
    MediaMetadata? metadata,
    EditMetadataStatus? status,
  }) {
    return EditMetadataState(
      audioPath: audioPath ?? this.audioPath,
      metadata: metadata ?? this.metadata,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [audioPath, metadata, status];
}
