import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/lib/audio/audio.dart';
import 'package:music_player/lib/utils/extensions/duration_extension.dart';

class PlayerSlider extends StatelessWidget {
  const PlayerSlider({super.key, required this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Duration position = context.watch<AudioCubit>().state.position;
    final Duration duration = context.watch<AudioCubit>().state.duration;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 15,
      child: Row(
        children: [
          Text(
            position.formatDurationInHHMMSS,
            style: TextStyle(
                fontSize: 11, color: color, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 5.0,
                // Set the track height (slider line width)
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                activeTrackColor: color ?? Colors.blue,
                // Active part of the slider
                inactiveTrackColor: color,
                // Inactive part of the slider
                thumbColor: color ?? Colors.blue,
                // Thumb color
                overlayColor: color?.withOpacity(0.2) ??
                    Colors.blue
                        .withOpacity(0.2), // Color when the thumb is pressed
              ),
              child: Slider(
                value: position.inSeconds
                    .clamp(0.0, duration.inSeconds.toDouble())
                    .toDouble(),
                min: 0,
                max: duration.inSeconds.toDouble(),
                onChanged: (value) {
                  context.read<AudioCubit>().seekTo(value.toInt());
                },
              ),
            ),
          ),
          const SizedBox(width: 2),
          Text(
            duration.formatDurationInHHMMSS,
            style: TextStyle(
                fontSize: 11, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
