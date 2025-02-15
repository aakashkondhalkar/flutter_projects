import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as prefix;
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:music_player/lib/home/home.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  // Create a player
  final AudioPlayer _audioPlayer = AudioPlayer();
  StreamSubscription? _playerStreamSubscription;
  StreamSubscription? _playerPositionStreamSubscription;
  StreamSubscription? _playerDurationStreamSubscription;
  List<MusicFile> _songs = [];
  bool isPlayingOnMiniPlayer = true;
  int? currentPlayingIndex;

  AudioCubit() : super(const AudioState()) {
    _playerStreamSubscription = _audioPlayer.playbackEventStream.listen(
      (event) async {
        if (_audioPlayer.playing) {
          var color = await _getColorFromImage(
              _songs[_audioPlayer.currentIndex!].metadata!.albumArt);
          var imagePath = await saveAndGetUint8ListAsJpg(
              _songs[_audioPlayer.currentIndex!].metadata!.albumArt);

          currentPlayingIndex = _audioPlayer.currentIndex;

          emit(state.copyWith(
            audioState: AudioProcessingState.playing,
            song: _songs[_audioPlayer.currentIndex!],
            color: color,
            imagePath: imagePath,
          ));
        } else {
          switch (event.processingState) {
            case ProcessingState.idle:
              emit(state.copyWith(audioState: AudioProcessingState.idle));
            case ProcessingState.loading:
              emit(state.copyWith(audioState: AudioProcessingState.loading));
            case ProcessingState.buffering:
              emit(state.copyWith(audioState: AudioProcessingState.buffering));
            case ProcessingState.ready:
              emit(state.copyWith(audioState: AudioProcessingState.ready));
            case ProcessingState.completed:
              emit(state.copyWith(audioState: AudioProcessingState.completed));
          }
        }
      },
    );
    _playerDurationStreamSubscription =
        _audioPlayer.durationStream.listen((duration) {
      emit(
        state.copyWith(
          duration: duration,
        ),
      );
    });

    _playerPositionStreamSubscription =
        _audioPlayer.positionStream.listen((position) {
      if (_audioPlayer.playing) {
        emit(
          state.copyWith(
            audioState: AudioProcessingState.playing,
            position: position,
          ),
        );
      }
    });
  }

  Future<void> initializePlaylist(List<MusicFile> songs) async {
    _songs = songs;
    // Define the playlist
    ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
      // Start loading next item just before reaching it
      useLazyPreparation: true,
      // Customise the shuffle algorithm
      shuffleOrder: DefaultShuffleOrder(),
      // Specify the playlist items
      children: songs
          .map(
            (e) => AudioSource.uri(
              Uri.parse(e.path),
              tag: MediaItem(
                // Specify a unique ID for each media item:
                id: e.id,
                // Metadata to display in the notification:
                album: e.metadata?.album ?? 'Unknown',
                title: e.metadata?.title ?? 'Unknown',
                // artUri: Uri.parse('${e.metadata?.albumArt}'),
              ),
            ),
          )
          .toList(),
    );

    await _audioPlayer.setAudioSource(
      playlist,
    );
  }

  Future<void> playAudio(int index, {bool autoPlay = true}) async {
    try {
      await _audioPlayer.pause();

      emit(
        state.copyWith(
          audioState: AudioProcessingState.pause,
        ),
      );

      await _audioPlayer.seek(Duration.zero,
          index: index); // Skip to the start of track3.mp3

      emit(
        state.copyWith(
          audioState: AudioProcessingState.ready,
        ),
      );

      await _audioPlayer.play();

      emit(
        state.copyWith(
          audioState: AudioProcessingState.playing,
        ),
      );
    } catch (e) {
      emit(state.copyWith(audioState: AudioProcessingState.error));
    }
  }

  Future<void> playPauseAudio() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
      emit(state.copyWith(audioState: AudioProcessingState.pause));
    } else {
      await _audioPlayer.play();
      emit(state.copyWith(audioState: AudioProcessingState.playing));
    }
  }

  Future<void> seekTo(int seconds) async {
    await _audioPlayer.seek(Duration(seconds: seconds));
  }

  Future<void> playNext() async {
    if (_audioPlayer.hasNext) {
      await _audioPlayer.seekToNext();

      emit(state.copyWith(
        audioState: AudioProcessingState.playNext,
      ));
    }
  }

  Future<void> playPrevious() async {
    if (_audioPlayer.hasPrevious) {
      await _audioPlayer.seekToPrevious();

      emit(state.copyWith(
        audioState: AudioProcessingState.playPrev,
      ));
    }
  }

  Future<void> stopAndDispose() async {
    await _audioPlayer.dispose();
    _playerStreamSubscription?.cancel();
    _playerDurationStreamSubscription?.cancel();
    _playerPositionStreamSubscription?.cancel();
  }

  Future<Color?> _getColorFromImage(List<int>? imageBytes) async {
    if (imageBytes == null) return null;

    final palette = await PaletteGenerator.fromImageProvider(prefix.MemoryImage(
      Uint8List.fromList(imageBytes),
    ));

    return palette.dominantColor!.color;
  }

  Future<String?> saveAndGetUint8ListAsJpg(List<int>? data) async {
    if (data == null) return null;
    // Get the device's temporary directory
    final cacheDirectory = await getApplicationCacheDirectory();
    final albumArtDirectory =
        await Directory("${cacheDirectory.path}/albumArtCache")
            .create(recursive: true);

    final albumArtImage =
        '${albumArtDirectory.path}/${DateTime.now().microsecondsSinceEpoch}.jpg';

    // Create a file and write the Uint8List as JPG
    final file = File(albumArtImage);
    await file.writeAsBytes(data);

    debugPrint('File saved at $albumArtImage');

    return albumArtImage;
  }

  @override
  Future<void> close() {
    _playerStreamSubscription?.cancel();
    _playerDurationStreamSubscription?.cancel();
    _playerPositionStreamSubscription?.cancel();
    return super.close();
  }
}
