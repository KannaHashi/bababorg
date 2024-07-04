import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bababorg/features/shared/widgets/AlbumTile.dart';
import 'Library/Album.dart';
import 'Library/RecentPlay.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  final TextEditingController _searchController = TextEditingController();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();
  int index = 0;

  List<SongModel> allSongs = [];
  List<AlbumModel> albums = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
          // color: Colors.black45,
          ),
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(25, 5, 25, 15),
            child: Text(
              'Albums',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: FutureBuilder<List<AlbumModel>>(
                future: _audioQuery.queryAlbums(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, album) {
                  if (album.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 10.0),
                          Text("Loading"),
                        ],
                      ),
                    );
                  }
                  if (album.data == null || album.data!.isEmpty) {
                    return const Center(child: Text("Nothing found!"));
                  }
                  albums = album.data!.sublist(1,4);
                  return Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Album(albumModel: album.data![index], albumList: albums),
                  );
                }),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 5, 25, 15),
            child: Text(
              'Recently Played',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: FutureBuilder<List<SongModel>>(
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
                  return RecentPlay(songModel: item.data!,);
                }),
          )
        ],
      ),
    ));
  }
}

class ArtWorkWidget extends StatelessWidget {
  final int id;
  const ArtWorkWidget({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: id,
      type: ArtworkType.AUDIO,
      artworkHeight: 200,
      artworkWidth: 200,
      artworkFit: BoxFit.cover,
      nullArtworkWidget: Image.asset('lib/images/oke.jpeg'),
    );
  }
}
