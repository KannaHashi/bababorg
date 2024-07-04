import 'dart:io';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'package:bababorg/features/shared/ui/screens/song_page.dart';
import 'package:bababorg/features/shared/widgets/MusicTile.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        // padding: EdgeInsets.symmetric(horizontal: size.width / 35),
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings and info'),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, size: size.width / 45),
            ),
            ListTile(
              leading: Icon(Icons.folder_open),
              title: Text('Folders'),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, size: size.width / 45),
            ),
            ListTile(
              leading: Icon(Icons.scatter_plot_rounded),
              title: Text('Scan Media'),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, size: size.width / 45),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings and info'),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, size: size.width / 45),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings and info'),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, size: size.width / 45),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings and info'),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, size: size.width / 45),
            ),
            const Divider(
              height: 3,
              thickness: 3,
              indent: 15,
              endIndent: 15,
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text('FeedBack'),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, size: size.width / 45),
            ),
            ListTile(
              leading: Icon(Icons.thumb_up_alt_outlined),
              title: Text('Rate Us'),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, size: size.width / 45),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Privacy'),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, size: size.width / 45),
            ),
            ListTile(
              leading: Icon(Icons.feed_rounded),
              title: Text('Terms of Use'),
              trailing:
                  Icon(Icons.arrow_forward_ios_rounded, size: size.width / 45),
            ),
          ],
        ),
      ),
    );
  }
}
