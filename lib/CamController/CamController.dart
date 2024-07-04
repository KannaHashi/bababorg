import 'package:bababorg/features/shared/ui/screens/MoodSync.dart';
import 'package:camera/camera.dart';

class CameraManager {
  MoodSyncState? moodsync;
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  String output = '';

  Future<CameraController?> load() async {
    cameras = await availableCameras();
    //Set front camera if available or back if not available
    int position = cameras!.length > 0 ? 1 : 0;
    cameraController = CameraController(
      cameras![position],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController!.initialize().then((value) {
      if (moodsync!.mounted) {
        return;
      } else {
        moodsync!.setState(() {
          cameraController!.startImageStream((imgStream) {
            
          });
        });
      }
    });
    return cameraController;
  }
}
