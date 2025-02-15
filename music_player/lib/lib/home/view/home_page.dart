import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:music_player/lib/audio/audio.dart';
import 'package:music_player/lib/edit_metadata/view/edit_metadata_page.dart';
import 'package:music_player/lib/utils/theme/app_colors.dart';

import '../home.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late AppLifecycleState? _state;
  late AppLifecycleListener? _listener;

  @override
  void initState() {
    super.initState();
    _state = SchedulerBinding.instance.lifecycleState;
    context.read<HomeCubit>().loadFileFromInternalStorage();
    _listener = AppLifecycleListener(
      onDetach: () async {
        await context.read<AudioCubit>().stopAndDispose();
      },
    );
  }

  @override
  void dispose() {
    _listener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final canShowAppBar =
        context.select((AudioCubit cubit) => cubit.isPlayingOnMiniPlayer);
    final currentPlayingIndex =
        context.select((AudioCubit cubit) => cubit.currentPlayingIndex);

    return Scaffold(
      appBar: !canShowAppBar
          ? null
          : AppBar(
              title: const Text("Songs"),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<HomeCubit>().pickMp3Files();
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
      body: Stack(
        children: [
          BlocConsumer<HomeCubit, HomeState>(
            listener: (context, state) {
              if (state is HomeSongsReadError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              } else if (state is HomeSongsReadCompleted) {
                context.read<AudioCubit>().initializePlaylist(state.songs);
              }
            },
            builder: (context, state) {
              return BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeSongsReading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeSongsReadCompleted) {
                    return GridView.builder(
                      padding: const EdgeInsets.only(
                          top: 16, right: 16, left: 16, bottom: 150),
                      itemCount: state.songs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        var metadata = state.songs[index].metadata;
                        var audioPath = state.songs[index].path;

                        return Card(
                          clipBehavior: Clip.hardEdge,
                          elevation: 0,
                          child: InkWell(
                            onTap: () {
                              if (currentPlayingIndex != index) {
                                context.read<AudioCubit>().playAudio(index);
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                if (metadata != null &&
                                    metadata.albumArt != null &&
                                    metadata.albumArt!.isNotEmpty)
                                  Image.memory(
                                    Uint8List.fromList(metadata.albumArt!),
                                    gaplessPlayback: true,
                                    fit: BoxFit.cover,
                                    height: double.maxFinite,
                                  ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.all(16),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Color(0xFF3B3C51),
                                        Colors.transparent
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    metadata?.title ??
                                        p.basename(state.songs[index].path),
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                if (currentPlayingIndex != null &&
                                    currentPlayingIndex == index)
                                  const Text(
                                    "Playing...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: IconButton(
                                      onPressed: () async {
                                        var result = await Navigator.push(
                                          context,
                                          EditMetadataPage.route(
                                              metadata: metadata,
                                              audioPath: audioPath),
                                        );

                                        if (result != null && result) {
                                          if (context.mounted) {
                                            context.read<HomeCubit>().loadFileFromInternalStorage();
                                          }
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.more_vert_rounded,
                                        color: AppColors.onBackground,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      child: const Text("Error"),
                    );
                  }
                },
              );
            },
          ),
          const AudioPlayerPage(),
        ],
      ),
    );
  }
}
