part of 'audio_cubit.dart';

enum AudioProcessingState {
  initial,
  loading,
  buffering,
  idle,
  ready,
  playing,
  pause,
  completed,
  error,
  seekForward,
  seekBackward,
  playNext,
  playPrev,
  shuffle,
}

@immutable
class AudioState extends Equatable {
  final AudioProcessingState audioState;
  final MusicFile? song;
  final Duration position;
  final Duration duration;
  final Color? color;
  final String? imagePath;

  const AudioState({
    this.audioState = AudioProcessingState.initial,
    this.song,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.color,
    this.imagePath,
  });

  AudioState copyWith({
    AudioProcessingState? audioState,
    MusicFile? song,
    Duration? position,
    Duration? duration,
    Color? color,
    String? imagePath,
  }) {
    return AudioState(
      audioState: audioState ?? this.audioState,
      song: song ?? this.song,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      color: color ?? this.color,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object?> get props =>
      [audioState, song, position, duration, color, imagePath];
}
