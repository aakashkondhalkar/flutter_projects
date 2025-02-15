import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/lib/audio/audio.dart';

class MediaPicture extends StatelessWidget {
  final double height;
  final double? width;
  final bool isExpanded;

  const MediaPicture({
    super.key,
    required this.height,
    this.width,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AudioCubit, AudioState, List<int>?>(
      selector: (state) => state.song?.metadata?.albumArt,
      builder: (context, image) {
        return Container(
          alignment: Alignment.center,
          height: height,
          width: width ?? height,
          margin: EdgeInsets.only(bottom: !isExpanded ? 0 : 50),
          child: (image != null && image.isNotEmpty)
              ? Image.memory(
                  Uint8List.fromList(image),
                  gaplessPlayback: true,
                  fit: BoxFit.cover,
                  height: double.maxFinite,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.music_note_rounded,
                      size: height * 0.6,
                    );
                  },
                )
              : Icon(
                  Icons.music_note_rounded,
                  size: height * 0.6,
                ),
        );
      },
    );
  }
}
