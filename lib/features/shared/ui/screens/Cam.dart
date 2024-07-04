import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';

class Cam extends StatefulWidget {
  const Cam({super.key});

  @override
  State<Cam> createState() => _CamState();
}

class _CamState extends State<Cam> {
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  CameraImage? camImage;
  XFile? capturedImage;
  String output = '';

  @override
  void initState() {
    super.initState();
    load();
    loadModel();
  }

  Future<void> load() async {
    cameras = await availableCameras();
    // Set front camera if available or back if not available
    int position = cameras!.length > 1 ? 1 : 0;
    cameraController = CameraController(
      cameras![position],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController!.startImageStream((imgStream) {
          camImage = imgStream;
          runModel();
        });
      });
    });
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
      isAsset: true, // defaults to true, set to false to load resources outside assets
      useGpuDelegate: false, // defaults to false, set to true to use GPU delegate
    );
  }

  Future<void> runModel() async {
    if (camImage != null) {
      var prediction = await Tflite.runModelOnFrame(
        bytesList: camImage!.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        imageHeight: camImage!.height,
        imageWidth: camImage!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        rotation: 90,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );
      prediction?.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });
    }
  }

  Future<void> captureImage() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        final imageFile = await cameraController!.takePicture();
        setState(() {
          capturedImage = imageFile;
        });
      } catch (e) {
        print("Error capturing image: $e");
      }
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          cameraController != null && cameraController!.value.isInitialized && capturedImage == null
              ? Container(
                  alignment: Alignment.center,
                  width: width,
                  height: height * 0.5,
                  child: CameraPreview(cameraController!),
                )
              : const Center(child: Text("Can't initialize device camera")),
          if (capturedImage != null)
            Container(
              padding: EdgeInsets.all(16),
              child: Image.file(File(capturedImage!.path)),
            ),
          SizedBox(height: height * 0.15),
          Text(
            output,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: captureImage,
        child: const Icon(Icons.camera),
      ),
    );
  }
}
