import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picture_msg/Services/auth.dart';
import 'package:picture_msg/Screens/Home/profile.dart';
import 'package:picture_msg/Chat/room_list_page.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';


final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser!;
final String _uid = user.uid.toString();
final AuthService _auth = AuthService();


class Home extends StatelessWidget {
  const Home({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;



  @override
  Widget build(BuildContext context) {
    String _username="";
    String _uid = user.uid.toString();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('PictureMSG',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.red,
          elevation: 0.0,
        ),

        body: TabBarView(
          children: [
            Container(
              child: MyHomePage(title: 'Home'),
            ),
            Container(
              child:  RoomListPage(),
            ),
            Container(
              child: const Profile(),
            ),
          ],
        ),

        bottomNavigationBar: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.sms),
              ),
              Tab(
                icon: Icon(Icons.account_box),
              ),
            ],
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.black38,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Theme.of(context).primaryColor
        ),
      ),
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
  String msg = 'create your master piece!';
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
      child: SingleChildScrollView(
          child: Column(
            children: [
              buildImage(),//diplay the custom image
              const SizedBox(height: 10),
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: 'Type here!',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: (){
                      setState((){
                        msg = _textController.text;
                      });
                    },
                    color: Colors.amber,
                    icon: const Icon(Icons.check),
                  ),
                    constraints: BoxConstraints(
                        maxWidth: 350,
                    )
                ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //signout of the app
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: Card(
                      child: RaisedButton(
                          child: Text(
                            'Save PicMSG',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.red,
                          onPressed: () async {
                            final image = await controller.captureFromWidget(buildImage());
                            if(image == null)return;
                            saveAndShare(image);
                            await saveImage(image);
                          }
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //signout of the app
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: Card(
                      child: RaisedButton(
                        child: Text(
                          'Save PicMSG',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.red,
                          onPressed: () async {
                            final image = await controller.captureFromWidget(buildImage());
                            if(image == null)return;
                            await saveImage(image);
                          }
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
        height: 350,
        fit: BoxFit.cover,
      ): FlutterLogo(size: 300),
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
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
      )
    ],
  );
}