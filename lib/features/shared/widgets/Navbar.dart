import 'package:flutter/material.dart';
import '../ui/screens/AllSongs.dart';

class BottomNavigationBarExample extends StatefulWidget {
  final int currentIndex = 0;
  get _selectedIndex => currentIndex;
  const BottomNavigationBarExample({super.key, required selectedIndex});
  

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 1: Playlist',
      style: optionStyle,
    ),
    AllSongs(),
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

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.music_note_outlined),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.queue_music_rounded),
          label: 'School',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
    );
  }
}
