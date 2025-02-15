import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mp3_metadata_retriever/models/media_metadata.dart';
import 'package:music_player/lib/upload/cubit/upload_image_cubit.dart';

import '../edit_metadata.dart';

class EditMetadataPage extends StatelessWidget {
  const EditMetadataPage({super.key});

  static Route<bool> route(
      {required MediaMetadata? metadata, required String audioPath}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => EditMetadataCubit(metadata, audioPath)),
          BlocProvider(
              create: (context) => UploadImageCubit(bytes: metadata?.albumArt)),
        ],
        child: const EditMetadataPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditMetadataCubit, EditMetadataState>(
      listener: (context, state) {
        if (state.status == EditMetadataStatus.success) {
          Navigator.pop(context, true);
        }
      },
      child: EditMetadataView(),
    );
  }
}

// ignore: must_be_immutable
class EditMetadataView extends StatelessWidget {
  EditMetadataView({super.key});

  final _formKey = GlobalKey<FormState>();
  String? _title;
  String? _artist;
  String? _album;
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Metadata'),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        color: Colors.transparent,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.maxFinite, 50),
          ),
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              _formKey.currentState?.save();
              MediaMetadata mediaMetadata = MediaMetadata(
                title: _title ?? "",
                artist: _artist ?? "",
                album: _album ?? "",
                duration: '',
                albumArt: _imagePath == null || _imagePath!.isEmpty
                    ? null
                    : File(_imagePath!).readAsBytesSync().toList(),
              );

              context.read<EditMetadataCubit>().changeMetadata(mediaMetadata);
              // Form is valid, you can process the data here
              debugPrint('Form submitted');
            }
          },
          child: const Text('Save'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: BlocConsumer<EditMetadataCubit, EditMetadataState>(
            listener: (context, state) {
              if (state.status == EditMetadataStatus.success) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Data saved successfully...")));
              } else if (state.status == EditMetadataStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Error occurred while editing metadata...")));
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: state.metadata?.title,
                    onSaved: (newValue) {
                      _title = newValue;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter text',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: state.metadata?.artist,
                    onSaved: (newValue) {
                      _artist = newValue;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter artist name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    initialValue: state.metadata?.album,
                    onSaved: (newValue) {
                      _album = newValue;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter album name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<UploadImageCubit, UploadImageState>(
                    buildWhen: (previous, current) {
                      if (current.status == ImageUploadStatus.success) {
                        return true;
                      } else if (current.status == ImageUploadStatus.initial) {
                        return true;
                      }
                      return false;
                    },
                    builder: (context, state) {
                      _imagePath = state.path;
                      Uint8List? imageBytes;
                      if (state.bytes != null) {
                        imageBytes = Uint8List.fromList(state.bytes!);
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: _imagePath != null
                                ? Image.file(File(_imagePath!),
                                    fit: BoxFit.cover)
                                : imageBytes != null
                                    ? Image.memory(imageBytes,
                                        fit: BoxFit.cover,
                                        gaplessPlayback: true)
                                    : Container(),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed:
                                context.read<UploadImageCubit>().pickImage,
                            child: Text(state.bytes == null &&
                                    (_imagePath == null || _imagePath!.isEmpty)
                                ? "Add Image"
                                : "Change Image"),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
