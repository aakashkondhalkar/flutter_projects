extension DurationExtension on Duration {
  String get formatDurationInHHMMSS {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    int hours = inHours;
    int minutes = inMinutes.remainder(60);
    int seconds = inSeconds.remainder(60);

    if (hours > 0) {
      // If hours are greater than 0, show hh:mm:ss
      return "${twoDigits(hours).padRight(2)}:${twoDigits(minutes).padRight(2)}:${twoDigits(seconds).padRight(2)}";
    } else {
      // If hours are 0 and seconds > 0, show mm:ss
      if (seconds > 0) {
        return "${twoDigits(minutes).padRight(2)}:${twoDigits(seconds).padRight(2)}";
      } else {
        // If seconds are 0, just show mm (minutes only)
        return twoDigits(minutes).padRight(2);
      }
    }
  }
}
