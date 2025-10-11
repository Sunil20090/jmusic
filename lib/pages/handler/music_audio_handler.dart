import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MusicAudioHandler extends BaseAudioHandler with SeekHandler {
  final AudioPlayer player;

  MusicAudioHandler({required this.player}) {
     player.playbackEventStream
        .map(_transformEvent)
        .pipe(playbackState);
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [MediaControl.play, MediaControl.pause, MediaControl.stop],
      systemActions: const {
        MediaAction.play,
        MediaAction.pause,
        MediaAction.stop,
      },
      playing: player.playing,
      processingState: AudioProcessingState.ready,
    );
  }

  @override
  Future<void> play() {
    player.play();
    return super.play();
  }

  @override
  Future<void> pause() {
    player.pause();
    return super.pause();
  }
}
