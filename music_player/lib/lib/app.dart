import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/lib/audio/audio.dart';
import 'package:music_player/lib/home/home.dart';
import 'package:music_player/lib/upload/cubit/upload_image_cubit.dart';
import 'package:music_player/lib/utils/utils.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        cardColor: Colors.white,
        scaffoldBackgroundColor: AppColors.background,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: AppColors.onBackground, fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0), // Rounded corners
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0), // Rounded corners
            borderSide: const BorderSide(color: Colors.lightGreen, width: 1.0), // Border color and width
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0), // Rounded corners
            borderSide: const BorderSide(color: Colors.green, width: 1.0), // Border color and width when focused
          ),
        ),
        textTheme: const TextTheme().copyWith(
          bodySmall: const TextStyle(color: Colors.white),
          bodyMedium: const TextStyle(color: Colors.white),
          bodyLarge: const TextStyle(color: Colors.white),
          labelSmall: const TextStyle(color: Colors.white),
          labelMedium: const TextStyle(color: Colors.white),
          labelLarge: const TextStyle(color: Colors.white),
          displaySmall: const TextStyle(color: Colors.white),
          displayMedium: const TextStyle(color: Colors.white),
          displayLarge: const TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          color: AppColors.primary,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AudioCubit(),
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}
