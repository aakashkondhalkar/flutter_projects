import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/lib/audio/audio.dart';

class SeekNextButton extends StatelessWidget {
  const SeekNextButton({super.key, required this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.skip_next, color: color, size: 32),
      onPressed: () {
        context.read<AudioCubit>().playNext();
      },
    );
  }
}

class SeekPreviousButton extends StatelessWidget {
  const SeekPreviousButton({super.key, required this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.skip_previous, color: color, size: 32),
      onPressed: () {
        context.read<AudioCubit>().playPrevious();
      },
    );
  }
}
