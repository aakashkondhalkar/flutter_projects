import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:music_player/lib/utils/extensions/color_extension.dart';
import 'package:music_player/lib/utils/utils.dart';

import '../audio.dart';

class AudioPlayerPage extends StatelessWidget {
  const AudioPlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AudioPlayer();
  }
}

class AudioPlayer extends StatelessWidget {
  const AudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocSelector<AudioCubit, AudioState, String?>(
      selector: (state) => state.imagePath,
      builder: (context, image) {
        return Miniplayer(
          minHeight: 130,
          maxHeight: size.height,
          elevation: 10,
          backgroundColor: Colors.black.withOpacity(0.2),
          builder: (height, percentage) {
            if (percentage > 0.2) {
              context.read<AudioCubit>().isPlayingOnMiniPlayer = false;
            } else {
              context.read<AudioCubit>().isPlayingOnMiniPlayer = true;
            }
            return BlocSelector<AudioCubit, AudioState, Color?>(
              selector: (state) => state.color,
              builder: (context, color) {
                var controlColor = color?.getContrastColor;
                return Stack(
                  children: [
                    // ImageFiltered(
                    //   imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       image: image != null && image.isNotEmpty
                    //           ? DecorationImage(
                    //               image: FileImage(File(image)),
                    //               fit: BoxFit.cover)
                    //           : null,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      color: color ?? AppColors.primary,
                      height: double.maxFinite,
                      width: double.maxFinite,
                    ),
                    (percentage > 0.2)
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: percentage < 1.0 ? 0 : kToolbarHeight),
                                child: MediaPicture(
                                    height: height * 0.4,
                                    isExpandedPlayer: true),
                              ),
                              MediaTitle(
                                  color: controlColor, isExpandedPlayer: true),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SeekPreviousButton(color: controlColor),
                                  PlayPauseButton(color: controlColor),
                                  SeekNextButton(color: controlColor),
                                ],
                              ),
                              PlayerSlider(color: controlColor),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MediaPicture(
                                height: height,
                                width: 120,
                                isExpandedPlayer: false,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SeekPreviousButton(color: controlColor),
                                        PlayPauseButton(color: controlColor),
                                        SeekNextButton(color: controlColor),
                                      ],
                                    ),
                                    MediaTitle(
                                        color: controlColor,
                                        isExpandedPlayer: false),
                                    PlayerSlider(color: controlColor),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
