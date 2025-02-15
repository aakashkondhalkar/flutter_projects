import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'upload_image_state.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  final String? path;
  final List<int>? bytes;

  UploadImageCubit({this.path, this.bytes})
      : super(UploadImageState(path: path, bytes: bytes));

  Future<void> pickImage() async {
    emit(state);
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        emit(state.copyWith(
          path: pickedFile.path,
          status: ImageUploadStatus.success,
        ));
      } else {
        emit(state.copyWith(
          status: ImageUploadStatus.success,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
          status: ImageUploadStatus.failed, message: e.toString()));
    }
  }
}
