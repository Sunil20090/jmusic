import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:jmusic/constants/sound_constant.dart';
import 'package:jmusic/pages/dashboard/song_list.dart';
import 'package:jmusic/pages/handler/music_audio_handler.dart';
import 'package:jmusic/pages/player_screen.dart';
import 'package:jmusic/utils/common_function.dart';
import 'package:just_audio/just_audio.dart';

void main() async {
  player = AudioPlayer();
  audioHandler = await AudioService.init(
    builder: () => MusicAudioHandler(player: player!),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.jmusic.channel.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  MyApp({super.key});

  // This widget is the root of your application.\

  // {
  //         'thumbnail':
  //             'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSq_AU6PEKHWGK_hxk69oROcyRJ3MBiGTH86A&s',
  //       }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SongList(),
    );
  }

  player() {
    return PlayerScreen(
      music: {
        "music_url": URL_SONG,
        "thumbnail":
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRgElpWVYUNBfFAmMK3vBrfoRVeLa_EeHkVw&s',
      },
    );
  }
}
