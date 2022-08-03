import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String msg = 'Hello';
  //getting the picture message
  final _textController = TextEditingController();

  File? image;

  Future gallery() async{//allows us to choose a picture from our gallery
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null)return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    }on PlatformException catch(e){
      print("Failed to pick image from gallery: $e");
    }
  }

  Future camera() async{//funtion allows us to take a picture with our camera and then display it
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if(image == null)return;

      final imageTemp = File(image.path);

      setState(() => this.image = imageTemp);
    }on PlatformException catch(e){
      print("Failed take image from camera: $e");
    }
  }

  Future<String> saveImage(Uint8List bytes) async{//this is the funtion that creates and save the picture message you create
    await [Permission.storage].request();
    final time = DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');
    final name = 'pictureMSG_$time';
    final result = await ImageGallerySaver.saveImage(bytes);
    return result['filePath'];
  }

  Future saveAndShare(Uint8List bytes) async{//this allows us to share the message to any social media area we want
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/flutter.png');
    image.writeAsBytes(bytes);

    //final text = 'from Picture MSG';
    await Share.shareFiles([image.path]);
  }

  final controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Image Picker"),
        ),
        body: Center(
          child: Column(
            children: [
              buildImage(),//diplay the custom image
              const SizedBox(height: 24),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Write you picture MSG',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: (){
                      _textController.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                    onPressed: (){
                      setState((){
                        msg = _textController.text;
                      });
                    },
                    color: Colors.red,
                    child: const Text('Confirm', style: TextStyle(color: Colors.white)),
                  ),

                  MaterialButton( //for choosing through gallery
                    color: Colors.red,
                    child: Text(
                      "Gallery",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold
                      ),
                    ),
                    onPressed: () {
                      gallery();
                    },
                  ),
                ],
              ),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton( //for choosing in camera
                      color: Colors.red,
                      child: Text(
                        "Camera",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold
                        ),
                      ),
                      onPressed: () {
                        camera();
                      },
                    ),

                    MaterialButton(//captures the picture message made to be a ble to send to other people
                        color: Colors.red,
                        child: Text(
                          "Share PICMSG",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold
                          ),
                        ),
                        onPressed: () async {
                          final image = await controller.captureFromWidget(buildImage());
                          if(image == null)return;
                          saveAndShare(image);
                          await saveImage(image);
                        }
                    ),
                  ]
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget buildImage() => Stack(
    children: [//this is out custom image we are setting
      image != null
          ? Image.file(
        image!,
        width: 400,
        height: 400,
        fit: BoxFit.cover,
      ): Text("No image was seclected"),
      Positioned(//This is where we set the postion of the writing
          bottom: 16,
          right: 0,
          left: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
              color: Colors.black,
              child: Text(
                msg,
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
          )
      )
    ],
  );
}