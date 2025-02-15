import 'dart:typed_data';

import 'package:audiotags/audiotags.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:mp3_metadata_retriever/models/media_metadata.dart';
import 'package:mp3_metadata_retriever/mp3_metadata_retriever.dart';

part 'edit_metadata_state.dart';

class EditMetadataCubit extends Cubit<EditMetadataState> {
  final MediaMetadata? metadata;
  final String audioPath;

  EditMetadataCubit(this.metadata, this.audioPath)
      : super(EditMetadataState(audioPath: audioPath, metadata: metadata));

  Future<void> changeMetadata(MediaMetadata mediaMetadata) async {
    try {
      emit(EditMetadataState(
          audioPath: audioPath,
          metadata: metadata,
          status: EditMetadataStatus.editing));
      Tag tag = Tag(
        title: mediaMetadata.title,
        trackArtist: mediaMetadata.artist,
        album: mediaMetadata.album,
        albumArtist: mediaMetadata.artist,
        pictures: [
          if (mediaMetadata.albumArt != null)
            Picture(
                bytes: Uint8List.fromList(mediaMetadata.albumArt!), pictureType: PictureType.other)
        ],
      );

      await AudioTags.write(audioPath, tag);
      emit(EditMetadataState(
          audioPath: audioPath,
          metadata: metadata,
          status: EditMetadataStatus.success));
    } catch (e) {
      emit(EditMetadataState(
          audioPath: audioPath,
          metadata: metadata,
          status: EditMetadataStatus.failure));
    }
  }
}
