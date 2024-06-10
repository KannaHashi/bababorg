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

class AllSongs extends StatefulWidget {
  const AllSongs({Key? key}) : super(key: key);

  @override
  State<AllSongs> createState() => _AllSongsState();
}

class _AllSongsState extends State<AllSongs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<SongModel> allSongs = [];
  bool _permissionsGranted = false;

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        permissionStatus = await _audioQuery.permissionsRequest();
      }
      setState(() {
        _permissionsGranted = permissionStatus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[800],
        title: const Text(
          "Bababorggggg Music Player",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 2,
      ),
      body: _permissionsGranted
          ? FutureBuilder<List<SongModel>>(
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SongPage(
                                      songModelList: allSongs,
                                      audioPlayer: _audioPlayer)));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 15, 15),
                          child: NeuBox(
                            child: Column(
                              children: [ 
                                Row(
                                  children: [
                                    MusicTile(songModel: SongModelProvider._id ? SongModelProvider._id)
                                  ],
                                )
                              ],
                            )
                            )
                          )
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
          : const Center(
              child: Text('Memerlukan izin untuk mengakses file audio'),
            ),
    );
  }
}
