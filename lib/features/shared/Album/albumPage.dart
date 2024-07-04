import 'package:bababorg/features/shared/ui/screens/song_page.dart';
import 'package:bababorg/features/shared/widgets/MusicTile.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import '../../../provider/song_model_provider.dart';
import 'package:bababorg/features/shared/ui/screens/neu_box.dart';

class AlbumPage extends StatefulWidget {
  final String album;
  final AlbumModel albumModel;
  final AudioPlayer audioPlayer;

  const AlbumPage(
      {Key? key,
      required this.audioPlayer,
      required this.album,
      required this.albumModel})
      : super(key: key);

  @override
  State<AlbumPage> createState() => AlbumPageState();
}

class AlbumPageState extends State<AlbumPage> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  final OnAudioQuery _audioQuery = OnAudioQuery();

  bool _isPlaying = false;
  late LoopMode loops;
  bool get isPlaying => _isPlaying;

  late bool songi;

  IconData loopsIcon = Icons.repeat;

  late var playlist;

  List<SongModel> allSongs = [];
  Iterable<SongModel> songs = [];
  List<AudioSource> songList = [];
  List<AudioSource> queue = [];

  int initIndex = 0;

  void popBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    AlbumModel albumb = widget.albumModel;
    return Scaffold(
        // backgroundColor: Colors.grey[300],
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
              // Filter songs based on albumId
              allSongs = item.data!
                  .where((song) => song.album == widget.album)
                  .toList();
              if (allSongs.isEmpty) {
                return const Center(
                    child: Text("No songs found for this album!"));
              }
              songList = allSongs.map((song) {
                return AudioSource.uri(Uri.parse(song.uri.toString()));
              }).toList();
              return SafeArea(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // back button and menu button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            popBack();
                          },
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        Text(widget.albumModel.album),
                        SizedBox(
                          height: 60,
                          width: 60,
                          child: NeuBoxDark(child: Icon(Icons.menu)),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // cover art, artist name, song name
                    NeuBoxDark(
                      child: Column(
                        children: [
                          Center(
                            child: QueryArtworkWidget(
                                id: widget.albumModel.id,
                                type: ArtworkType.ALBUM,
                                quality: 100,
                                artworkQuality: FilterQuality.high,
                                artworkHeight: MediaQuery.of(context).size.height / 3,
                                artworkWidth: 500,
                                artworkFit: BoxFit.cover,
                                artworkBorder: BorderRadius.circular(15),
                                nullArtworkWidget:
                                    Image.asset('assets/images/oke.jpeg', height: 220, width: 350, fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.albumModel.album,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width / 20,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      widget.albumModel.artist.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: size.width / 30,
                                          color: Colors.grey.shade200,
                                          overflow: TextOverflow.fade),
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 32,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(5),
                      child: Stack(children: [
                        ListView.builder(
                          itemCount: allSongs.length,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SongPage(
                                        index: index,
                                        songModelList: allSongs,
                                        audioPlayer: widget.audioPlayer,
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
                                child: MusicTile(songModel: allSongs[index]),
                            );
                          },
                        ),
                      ]),
                    )
                  ],
                ),
              ));
            }));
  }
}

class ArtWorkWidget extends StatelessWidget {
  const ArtWorkWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
        id: context.watch<SongModelProvider>().id,
        type: ArtworkType.ALBUM,
        quality: 100,
        artworkQuality: FilterQuality.high,
        artworkHeight: 500,
        artworkWidth: 500,
        artworkFit: BoxFit.cover,
        nullArtworkWidget: Image.asset('assets/images/oke.jpeg'));
  }
}
