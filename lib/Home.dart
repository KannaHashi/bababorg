import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audio_service/audio_service.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:bababorg/features/shared/widgets/Navbar.dart';
import 'package:bababorg/features/shared/ui/screens/AllSongs.dart';
import 'package:bababorg/provider/song_model_provider.dart';
import 'package:bababorg/features/shared/ui/screens/song_page.dart';
import 'package:bababorg/features/shared/ui/screens/Library.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();

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

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Library(),
    AllSongs(),
    Text(
      'Index 2: Profile',
      style: optionStyle,
    ),
    Text(
      'Index 2: Profile',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    int currentSongId = context.watch<SongModelProvider>().id;
    int currentIndex = 0;

    return Scaffold(
      body: _permissionsGranted
          ? SafeArea(
            child:  _widgetOptions.elementAt(_selectedIndex)
          )
          : const Center(
              child: Text('Memerlukan izin untuk mengakses file audio'),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_rounded),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.queue_music_outlined),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.face_retouching_natural),
            label: 'Emo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_4),
            label: 'Library',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple[300],
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
