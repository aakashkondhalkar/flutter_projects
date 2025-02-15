import 'package:mp3_metadata_retriever/models/media_metadata.dart';

class MusicFile {
  final String id;
  final String path;
  final MediaMetadata? metadata;

  MusicFile(this.id, this.path, this.metadata);
}
