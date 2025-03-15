import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/lib/audio/cubit/audio_cubit.dart';

class MediaTitle extends StatelessWidget {
  final Color? color;
  final double fontSize;
  final bool isExpandedPlayer;

  const MediaTitle(
      {super.key,
      required this.color,
      this.fontSize = 14,
      required this.isExpandedPlayer});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AudioCubit, AudioState, String>(
      selector: (state) => state.song?.metadata?.title ?? "Unknown",
      builder: (context, title) {
        return Container(
          padding: EdgeInsets.only(
              left: 16, right: 16, bottom: isExpandedPlayer ? 16 : 8),
          child: Text(
            title,
            maxLines: isExpandedPlayer ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
            ),
          ),
        );
      },
    );
  }
}
