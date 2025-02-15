import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_metadata_retriever/mp3_metadata_retriever.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:music_player/lib/home/home.dart';
import 'package:uuid/uuid.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final _mp3MetadataRetrieverPlugin = Mp3MetadataRetriever();

  final String songsFolderName = "MySongs";
  var uuid = const Uuid();

  Future<void> loadFileFromInternalStorage() async {
    try {
      if (await Permission.manageExternalStorage.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        emit(HomeSongsReading());
        var storages = await ExternalPath.getExternalStorageDirectories();
        var internalStoragePath = storages.firstOrNull;
        List<MusicFile> songs = [];

        if (internalStoragePath != null) {
          var path = "$internalStoragePath/$songsFolderName";
          var files = Directory(path).listSync();
          // remove files from list
          files.removeWhere((f) => p.basename(f.path).startsWith("."));

          var mp3Files = files.where((f) {
            return p.basename(f.path).endsWith(".mp3");
          });
          for (var mp3 in mp3Files) {
            var mediaMetadata =
                await _mp3MetadataRetrieverPlugin.getMetadata(mp3.path);
            if (mediaMetadata != null) {
              if (mediaMetadata.title.isEmpty ||
                  mediaMetadata.title.toLowerCase() == "unknown") {
                mediaMetadata.title = p.basename(mp3.path);
              }
              songs.add(MusicFile(uuid.v4(), mp3.path, mediaMetadata));
            }
          }
        }
        emit(HomeSongsReadCompleted(songs));
      }
    } catch (e) {
      emit(HomeSongsReadError(e.toString()));
    }
  }

  Future<void> pickMp3Files() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['mp3'],
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        var storages = await ExternalPath.getExternalStorageDirectories();
        var internalStoragePath = storages.firstOrNull;
        List<File> addedFiles = [];
        if (internalStoragePath != null) {
          var destinationPath = "$internalStoragePath/$songsFolderName";

          for (var e in files) {
            addedFiles.add(File(e.path)
                .copySync(p.join(destinationPath, p.basename(e.path))));
          }
        }
        loadFileFromInternalStorage();
      }
    } catch (e) {
      rethrow;
    }
  }
}
