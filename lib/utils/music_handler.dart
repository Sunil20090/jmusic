import 'package:jmusic/modals/song_modal.dart';
import 'package:just_audio/just_audio.dart';

class MusicHandler {
  static AudioPlayer? audioPlayer;
  static SongModal? current_song;
  static bool isPlaying = false;

  static play() async {
    if (audioPlayer != null) {
      isPlaying = true;
      await audioPlayer!.play();
    }
  }

  static dispose() async {
    if (audioPlayer != null) {
      isPlaying = false;
      await audioPlayer!.dispose();
    }
  }

  static pause() async {
    if (audioPlayer != null) {
      isPlaying = false;
      await audioPlayer!.pause();
    }
  }
}
