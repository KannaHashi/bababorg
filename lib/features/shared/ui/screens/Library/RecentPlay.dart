import 'dart:io';
import 'package:bababorg/provider/song_model_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'package:bababorg/features/shared/ui/screens/song_page.dart';
import 'package:bababorg/features/shared/widgets/AlbumTile.dart';

class RecentPlay extends StatefulWidget {
  final List<SongModel> songModel;
  const RecentPlay({super.key, required this.songModel});

  @override
  State<RecentPlay> createState() => _RecentPlayState();
}

class _RecentPlayState extends State<RecentPlay> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> songs = [];
  List<SongModel> songsIndex = [];
  List<AudioSource> songList = [];

  @override
  void initState() {
    super.initState();
    songList = songs.map((song) {
      return AudioSource.uri(Uri.parse(song.uri.toString()));
    }).toList();
  }

  int indexx = 1;

  @override
  Widget build(BuildContext context) {
    songs = widget.songModel;

    return CarouselSlider(
      options: CarouselOptions(
        height: 250,
        aspectRatio: 16 / 9,
        viewportFraction: 0.45,
        initialPage: 0,
        enableInfiniteScroll: false,
        reverse: false,
        autoPlay: false,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: false,
        scrollDirection: Axis.horizontal,
      ),
      items: songs.map((song) {
        for (final (int, SongModel) item in songs.indexed) {
          final index = item.$1;
          if (song == songs[index]) {
            indexx = index;
          }
        }
        return Builder(
          builder: (BuildContext context) {
            Size size = MediaQuery.of(context).size;
            return GestureDetector(
              onTap: () {
                context.read<SongModelProvider>().setId(song.id);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SongPage(
                      index: indexx,
                      songModelList: songs,
                      audioPlayer: _audioPlayer,
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    QueryArtworkWidget(
                      id: song.id,
                      type: ArtworkType.AUDIO,
                      artworkQuality: FilterQuality.high,
                      artworkBorder: BorderRadius.circular(8),
                      nullArtworkWidget: Image.asset(
                        'assets/images/oke.jpeg',
                        // fit: BoxFit.cover,
                        width: size.width / 3,
                        height: size.width / 3.5,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                      ),
                      artworkWidth: size.width / 3,
                      artworkHeight: size.width / 3.5,
                      artworkFit: BoxFit.cover,
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.title,
                                  overflow: TextOverflow.ellipsis,
                                  textScaler: TextScaler.linear(0.8),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  song.artist ?? "Unknown Artist",
                                  overflow: TextOverflow.ellipsis,
                                  textScaler: TextScaler.linear(0.8),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: size.width / 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
