import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audio_service/audio_service.dart';
import '../provider/song_model_provider.dart';
import 'package:provider/provider.dart';

class SongHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();
  List<SongModel> allSongs = [];
  bool _permissionsGranted = false;

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        permissionStatus = await _audioQuery.permissionsRequest();
      }
      _permissionsGranted = true;
    }
     
    // Listen for changes in the current song index and update the media item
    void _listenForCurrentSongIndexChanges() {
      audioPlayer.currentIndexStream.listen((index) {
        final playlist = queue.value;
        if (index == null || playlist.isEmpty) return;
        mediaItem.add(playlist[index]);
      });
    }
  }
  
}

final playlist = ConcatenatingAudioSource(
  // Start loading next item just before reaching it
  useLazyPreparation: true,
  // Customise the shuffle algorithm
  shuffleOrder: DefaultShuffleOrder(),
  // Specify the playlist items
  children: [
    AudioSource.uri(Uri.parse('https://example.com/track1.mp3')),
    AudioSource.uri(Uri.parse('https://example.com/track2.mp3')),
    AudioSource.uri(Uri.parse('https://example.com/track3.mp3')),
  ],
);
