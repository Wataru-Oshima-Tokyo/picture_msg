import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';



class CameraApp extends StatelessWidget {

  const CameraApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //
    //   theme: ThemeData(),
    //   home: Camera_Photo(camera: camera),
    // );
    return Scaffold(
      appBar: AppBar(
          title: Text('Camera'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueAccent,
      ),
      body: Camera_Photo(camera: camera),
    );
  }
}

class Camera_Photo extends StatefulWidget {
  const Camera_Photo({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  Camera_Photo_State createState() => Camera_Photo_State();
}

class Camera_Photo_State extends State<Camera_Photo> {
  late CameraController controller;
  late Future<void> initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    initializeControllerFuture = controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<void>(
          future: initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(controller);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // take a photo
          final image = await controller.takePicture();
          // transfer to the screen
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DisplayPictureScreen(imagePath: image.path),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// display the photo
class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('The taken photo')),
      body: Center(child: Image.file(File(imagePath))),
    );
  }
}