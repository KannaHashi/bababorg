import 'package:bababorg/services/song_handler.dart';
import 'package:flutter/material.dart';
import 'package:bababorg/provider/song_model_provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/shared/ui/screens/AllSongs.dart';
import 'Home.dart';

SongHandler _songHandler = SongHandler();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => SongModelProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 42, 48, 82), brightness: Brightness.dark),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 15,
            color: Colors.white
          ),
          bodyMedium: GoogleFonts.poppins(color: Colors.white)
        )
      ),
      home: const Home(),
    );
  }
}
