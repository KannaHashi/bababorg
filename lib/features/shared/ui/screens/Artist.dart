import 'dart:io';
import 'dart:async';
import 'package:bababorg/features/shared/widgets/ArtistTile.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'package:bababorg/features/shared/ui/screens/song_page.dart';
import 'package:bababorg/features/shared/widgets/MusicTile.dart';
import '../../../../provider/song_model_provider.dart';
import 'package:progress_border/progress_border.dart';

class Artist extends StatefulWidget {
  const Artist({super.key});

  @override
  State<Artist> createState() => _ArtistState();
}

class _ArtistState extends State<Artist>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> allSongs = [];
  List<AudioSource> songList = [];
  List<ArtistModel> artistModel = [];

  Duration dur = const Duration();
  Duration _position = const Duration();
  bool _isPlaying = false;
  int initIndex = 0;

  late final animationController = AnimationController(
    vsync: this,
    // this isthe duration of the progress
    duration: dur,
  );

  @override
  void initState() {
    super.initState();
    animationController.addListener(() {
      setState(() {
        _audioPlayer.durationStream.listen((durs) {
          if (durs != null) {
            setState(() {
              dur = durs;
            });
          }
        });
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void restart() {
    if (animationController.status == AnimationStatus.forward ||
        animationController.value >= 1) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentSongId = context.watch<SongModelProvider>().id;

    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   title: Container(
      //     margin: const EdgeInsets.fromLTRB(8, 20, 8, 20),
      //     child: TextField(
      //       controller: _searchController,
      //       style: const TextStyle(color: Colors.white),
      //       cursorColor: Colors.white,
      //       decoration: InputDecoration(
      //         hintText: 'Search song...',
      //         hintStyle: const TextStyle(color: Colors.white54),
      //         border: OutlineInputBorder(
      //           borderRadius: BorderRadius.circular(50),
      //         ),
      //         icon: const Icon(Icons.search_rounded),
      //       ),
      //     ),
      //   ),
      // ),
      body: FutureBuilder<List<ArtistModel>>(
        future: _audioQuery.queryArtists(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10.0),
                  Text("Loading"),
                ],
              ),
            );
          }
          if (item.data == null || item.data!.isEmpty) {
            return const Center(child: Text("Nothing found!"));
          }
          artistModel = item.data!;
          return Stack(
            children: [
              ListView.builder(
                itemCount: item.data!.length,
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                itemBuilder: (context, index) {
                  initIndex = index;
                  return GestureDetector(
                    onTap: () {
                      Iterable<SongModel> songs = allSongs
                          .takeWhile((song) => song.id >= currentSongId);
                      restart();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Art
                      //   ),
                      // );
                    },
                    onLongPress: () {
                      showMenu(
                          context: context,
                          position: RelativeRect.fill,
                          items: <PopupMenuEntry>[
                            PopupMenuItem(
                              child: Text('data'),
                            ),
                            PopupMenuItem(
                              child: Text('data'),
                            ),
                            PopupMenuItem(
                              child: Text('data'),
                            ),
                            PopupMenuItem(
                              child: Text('data'),
                            ),
                          ]);
                    },
                    child: ArtistTile(artistModel: item.data![index],),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
