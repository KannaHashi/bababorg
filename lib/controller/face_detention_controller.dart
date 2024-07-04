import 'package:bababorg/module/face_model.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetetorController {
  FaceDetector? _faceDetector;

  Future<List<FaceModel>?> processImage(inputImage) async {
    _faceDetector = FaceDetector(options: FaceDetectorOptions(enableClassification: true, enableContours: true));

    final faces = await _faceDetector?.processImage(inputImage);
    return extractFaceInfo(faces);
  }

  List<FaceModel>? extractFaceInfo(List<Face>? faces) {
    List<FaceModel>? response = [];
    double? smile;
    double? leftEyes;
    double? rightEyes;

    for (Face face in faces!) {
      final rect = face.boundingBox;
      if (face.smilingProbability != null) {
        smile = face.smilingProbability;
      }

      leftEyes = face.leftEyeOpenProbability;
      rightEyes = face.rightEyeOpenProbability;

      final faceModel = FaceModel(
        smile: smile,
        leftEyeOpen: leftEyes,
        rightEyeOpen: rightEyes,
      );

      response.add(faceModel);
    }

    return response;
  }
}
