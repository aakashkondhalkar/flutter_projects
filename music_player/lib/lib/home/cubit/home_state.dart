part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeSongsReading extends HomeState {}

final class HomeSongsReadCompleted extends HomeState {
  final List<MusicFile> songs;

  HomeSongsReadCompleted(this.songs);
}

final class HomeSongsReadError extends HomeState {
  final String error;

  HomeSongsReadError(this.error);
}

// Picker
//
// final class HomeAddingNewSongs extends HomeState {
//   HomeAddingNewSongs();
// }
//
// final class HomeAddedNewSongs extends HomeState {
//   final List<File> files;
//   HomeAddedNewSongs({required this.files});
// }
//
// final class HomeAddNewSongsError extends HomeState {
//   final String error;
//
//   HomeAddNewSongsError(this.error);
// }
