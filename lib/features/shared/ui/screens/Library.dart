import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

  @override
  Widget build(BuildContext context) {
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
        title: Container(
          margin: const EdgeInsets.fromLTRB(8, 20, 8, 20),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: InputDecoration(
              hintText: 'Search song...',
              hintStyle: TextStyle(color: Colors.white54),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              icon: Icon(Icons.search_rounded),
            ),
          ),
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
          return Container(
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
                    'Baru Saja Diputar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 500,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.65,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.3,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: allSongs.map((song) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.symmetric(vertical: 25),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(75)
                          ),
                          child: Column(
                            children: [
                              QueryArtworkWidget(
                                id: song.id,
                                type: ArtworkType.AUDIO,
                                nullArtworkWidget: Image.asset(
                                  'lib/images/oke.jpeg',
                                  fit: BoxFit.cover,
                                  width: 280,
                                  height: 280,
                                ),
                                artworkHeight: 280,
                                artworkWidth: 280,
                                artworkFit: BoxFit.cover,
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          song.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          song.artist ?? "Unknown Artist",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            overflow: TextOverflow.ellipsis,
                                          ),
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
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
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
