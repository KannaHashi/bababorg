import 'dart:io';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'package:bababorg/features/shared/ui/screens/song_page.dart';
import 'package:bababorg/features/shared/widgets/AlbumTile.dart';

class Album extends StatefulWidget {
  final AlbumModel albumModel;
  final List<AlbumModel> albumList;

  const Album({super.key, required this.albumModel, required this.albumList});

  @override
  State<Album> createState() => _AlbumState();
}

class _AlbumState extends State<Album> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  int index = 0;

  List<AlbumModel> albums = [];

  get albumList => widget.albumList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(albumList.length, (index) {
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: QueryArtworkWidget(
                  id: albumList[index].id,
                  type: ArtworkType.ALBUM,
                  artworkBorder: BorderRadius.circular(7),
                  nullArtworkWidget: Icon(Icons.music_note),
                ),
                title: Text(
                  this.albumList[index].album,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  this.albumList[index].artist.toString(),
                  overflow: TextOverflow.ellipsis,
                )
              ),
            ],
          ),
        );
      }),
    );
  }
}
