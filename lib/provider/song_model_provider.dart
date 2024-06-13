import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongModelProvider with ChangeNotifier {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  
  int _id = 0;

  int get id => _id;

  void setId(int id) {
    _id = id;
    notifyListeners();
  }
}
