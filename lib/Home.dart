import 'dart:io';

import 'package:bababorg/features/shared/ui/screens/Albums.dart';
import 'package:bababorg/features/shared/ui/screens/Artist.dart';
import 'package:bababorg/features/shared/ui/screens/Cam.dart';
import 'package:bababorg/features/shared/ui/screens/Library/Folder.dart';
import 'package:bababorg/features/shared/ui/screens/Playlist.dart';
import 'package:bababorg/features/shared/ui/screens/Settings/Settings.dart';
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
import 'package:bababorg/features/shared/ui/screens/MoodSync.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  final AudioPlayer _audioPlayer = AudioPlayer();

  List<SongModel> allSongs = [];
  bool _permissionsGranted = false;

  late TabController _tabController;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    requestPermission();
    _tabController = TabController(vsync: this, length: 5);
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

  var title = '';
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Library(),
    AllSongs(),
    Moodsync(),
    Playlist(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        title = 'Bababorg';
      } else if (index == 1) {
        title = 'Songs';
      } else if (index == 2) {
        title = 'Find music with face expression';
      } else if (index == 3) {
        title = 'Playlist';
      } else if (index == 4) {
        title = 'Settings';
      }
    });
  }

  Widget build(BuildContext context) {
    int currentSongId = context.watch<SongModelProvider>().id;
    int currentIndex = 0;
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '$title' != '' ? '$title' : 'MoodSync',
          ),
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cam()
                    ),
                  );
                },
                icon: Icon(Icons.emoji_emotions_outlined)),
            Icon(
              // onPressed: (){},
              Icons.more_vert_sharp,
            ),
          ],
          bottom: TabBar(
            dividerHeight: 0,
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.library_music)),
              Tab(icon: Icon(Icons.music_note)),
              Tab(icon: Icon(Icons.album)),
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: _permissionsGranted
            ? TabBarView(
                controller: _tabController,
                children: <Widget>[
                  SafeArea(child: Library()),
                  SafeArea(child: AllSongs()),
                  SafeArea(child: Albums()),
                  SafeArea(child: Artist()),
                  SafeArea(child: Settings()),
                ],
              )
            : const Center(
                child: Text('Memerlukan izin untuk mengakses file audio'),
              ),
      ),
    );
  }
}
