part of 'upload_image_cubit.dart';

enum ImageUploadStatus {
  initial,
  loading,
  selecting,
  success,
  failed,
}

final class UploadImageState extends Equatable {
  final String? path;
  final List<int>? bytes;
  final ImageUploadStatus status;
  final String? message;

  const UploadImageState({
    this.path,
    this.bytes,
    this.status = ImageUploadStatus.initial,
    this.message,
  });

  UploadImageState copyWith({
    String? path,
    List<int>? bytes,
    ImageUploadStatus? status,
    String? message,
  }) {
    return UploadImageState(
      path: path ?? this.path,
      bytes: bytes ?? this.bytes,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [path, status, message];
}
