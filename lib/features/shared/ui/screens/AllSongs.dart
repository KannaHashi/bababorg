import 'dart:io';
import 'package:bababorg/features/shared/ui/screens/neu_box.dart';
import 'package:bababorg/features/shared/ui/screens/song_page.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../../../provider/song_model_provider.dart';
import '../../widgets/MusicTile.dart';
import 'NowPlaying.dart';
import '../../widgets/Navbar.dart';

class AllSongs extends StatefulWidget {
  const AllSongs({Key? key}) : super(key: key);

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  final TextEditingController _searchController = TextEditingController();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<SongModel> allSongs = [];
  
  @override
  Widget build(BuildContext context) {
    int currentSongId = context.watch<SongModelProvider>().id;
    // int currentIndex = context.watch<BottomNavigationBarExample>().currentIndex;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple.shade300],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Container(margin: const EdgeInsets.fromLTRB(8, 20, 8, 20),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Search song...',
              hintStyle: TextStyle(color: Colors.white54),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              icon: Icon(Icons.search_rounded)
            ),
        )
      ),
      ),
      body: FutureBuilder<List<SongModel>>(
              future: _audioQuery.querySongs(
                sortType: null,
                orderType: OrderType.ASC_OR_SMALLER,
                uriType: UriType.EXTERNAL,
                ignoreCase: true,
              ),
              builder: (context, item) {
                if (item.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text("Loading"),
                      ],
                    ),
                  );
                }
                if (item.data == null || item.data!.isEmpty) {
                  return const Center(child: Text("Nothing found!"));
                }
                allSongs = item.data!;
                return Stack(
                  children: [
                    ListView.builder(
                      itemCount: item.data!.length,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<SongModelProvider>()
                                .setId(item.data![index].id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SongPage(
                                        songModelList: [item.data![index]],
                                        audioPlayer: _audioPlayer)));
                          },
                          child: MusicTile(
                            songModel: item.data![index],
                          ),
                        );
                      },
                    ),
                    if (currentSongId != 0)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: () {
                            SongModel? currentSong = allSongs.firstWhere(
                                (song) => song.id == currentSongId,);
                            if (currentSong != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SongPage(
                                          songModelList: [currentSong],
                                          audioPlayer: _audioPlayer)));
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
                                      nullArtworkWidget: Icon(Icons.music_note),
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
                                          .artist ?? "Unknown Artist",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: CircleAvatar(
                                      child: Icon(Icons.play_arrow_rounded),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            )
          // bottomNavigationBar: BottomNavigationBarExample(selectedIndex: currentIndex)
    );
  }
}
