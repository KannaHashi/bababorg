import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'package:bababorg/features/shared/ui/screens/song_page.dart';
import 'package:bababorg/features/shared/widgets/MusicTile.dart';
import '../../../../provider/song_model_provider.dart';
import 'package:progress_border/progress_border.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({super.key});

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> allSongs = [];
  List<AudioSource> songList = [];

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
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
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
          allSongs = item.data!;
          songList = item.data!.map((song) {
            return AudioSource.uri(Uri.parse(song.uri.toString()));
          }).toList();
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SongPage(
                            index: index,
                            songModelList: allSongs,
                            audioPlayer: _audioPlayer,
                          ),
                        ),
                      );
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
                    child: MusicTile(songModel: item.data![index]),
                  );
                },
              ),
              if (currentSongId != 0)
                StreamBuilder<PlayerState>(
                    stream: _audioPlayer.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final processingState = playerState?.processingState;
                      final playing = playerState?.playing;
                      if (!(playing ?? false)) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              SongModel? currentSong = allSongs.firstWhere(
                                  (song) => song.id == currentSongId);
                              if (currentSong != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongPage(
                                      index: initIndex,
                                      songModelList: allSongs,
                                      audioPlayer: _audioPlayer,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: QueryArtworkWidget(
                                        id: currentSongId,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget:
                                            Icon(Icons.music_note),
                                      ),
                                      title: Text(
                                        allSongs
                                            .firstWhere((song) =>
                                                song.id == currentSongId)
                                            .title,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        allSongs
                                                .firstWhere((song) =>
                                                    song.id == currentSongId)
                                                .artist ??
                                            "Unknown Artist",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.purple.withAlpha(100),
                                            shape: BoxShape.circle,
                                            border: ProgressBorder.all(
                                              color: Colors.blue,
                                              width: 2,
                                              progress:
                                                  animationController.value,
                                            )),
                                        child: CircleAvatar(
                                          child: IconButton(
                                              onPressed: () {
                                                _audioPlayer.play();
                                                // playerState?.!playing;
                                              },
                                              icon: Icon(Icons.play_arrow)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else if (processingState != ProcessingState.completed) {
                        return Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              SongModel? currentSong = allSongs.firstWhere(
                                  (song) => song.id == currentSongId);
                              if (currentSong != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SongPage(
                                      index: initIndex,
                                      songModelList: allSongs,
                                      audioPlayer: _audioPlayer,
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 8),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: QueryArtworkWidget(
                                        id: currentSongId,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget:
                                            Icon(Icons.music_note),
                                      ),
                                      title: Text(
                                        allSongs
                                            .firstWhere((song) =>
                                                song.id == currentSongId)
                                            .title,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        allSongs
                                                .firstWhere((song) =>
                                                    song.id == currentSongId)
                                                .artist ??
                                            "Unknown Artist",
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      trailing: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.purple.withAlpha(100),
                                            shape: BoxShape.circle,
                                            border: ProgressBorder.all(
                                              color: Colors.blue,
                                              width: 2,
                                              progress:
                                                  animationController.value,
                                            )),
                                        child: CircleAvatar(
                                          child: IconButton(
                                              onPressed: () {
                                                _audioPlayer.pause();
                                                // playerState?.!playing;
                                              },
                                              icon: Icon(Icons.pause)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return CircleAvatar(
                        child: Icon(Icons.play_arrow_rounded),
                      );
                    })
            ],
          );
        },
      ),
    );
  }
}
