import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongModelProvider with ChangeNotifier {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  
  List<SongModel> allSongs = [];
  List<SongModel> get songList => allSongs;

  void setSongs(List<SongModel> allsong) {
    allSongs = allsong;
  }

  int _id = 0;
  bool _isPlaying = false;

  int get id => _id;
  bool get isPlaying => _isPlaying;

  void setId(int id) {
    _id = id;
    notifyListeners();
  }

  setPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }
}
