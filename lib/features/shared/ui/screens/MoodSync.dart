import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Audio
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

// CAM
import 'package:camera/camera.dart';
// import 'package:camerawesome/camerawesome_plugin.dart';

// UI
import 'package:bababorg/features/shared/ui/screens/song_page.dart';
import 'package:bababorg/features/shared/widgets/MusicTile.dart';

//Provider
import 'package:bababorg/provider/song_model_provider.dart';

//Controller
import 'package:bababorg/controller/home_controller.dart';

class Moodsync extends StatefulWidget {
  const Moodsync({super.key});
  
  @override
  State<Moodsync> createState() => MoodSyncState();
}

class MoodSyncState extends State<Moodsync> {
  final _homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Emotion'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        child: Icon(Icons.camera_alt),
      ),
      body: GetBuilder<HomeController>(
        init: _homeController,
        initState: (_) async {
          await _homeController.loadCamera();
          _homeController.startImageStream();
        },
        builder: (_) {
          return Container(
            child: Column(
              children: [
                _.cameraController != null &&
                        _.cameraController!.value.isInitialized
                    ? Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: CameraPreview(_.cameraController!))
                    : Center(child: Text('loading')),
                SizedBox(height: 15),
                Text(
                  '${_.label}',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}