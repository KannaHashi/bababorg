import 'dart:io';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'package:bababorg/features/shared/ui/screens/song_page.dart';
import 'package:bababorg/features/shared/widgets/MusicTile.dart';
import '../../../../provider/song_model_provider.dart';

class Playlist extends StatefulWidget {
  const Playlist({super.key});
  
  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}