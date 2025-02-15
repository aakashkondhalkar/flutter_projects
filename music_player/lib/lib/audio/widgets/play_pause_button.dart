import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/lib/audio/audio.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({super.key, required this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AudioCubit, AudioState, AudioProcessingState>(
        selector: (state) => state.audioState,
        builder: (context, audioState) {
          return Center(
            child: audioState == AudioProcessingState.buffering
                ? const SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(strokeWidth: 1))
                : IconButton(
                    icon: Icon(
                      audioState == AudioProcessingState.playing
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: color,
                      size: 60,
                    ),
                    onPressed: () =>
                        context.read<AudioCubit>().playPauseAudio(),
                  ),
          );
        });
  }
}
