import 'package:flutter/material.dart';
import 'package:picture_msg/Chat/room_list_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:picture_msg/Services/auth.dart';
import 'package:picture_msg/Screens/Home/home.dart';
import 'package:picture_msg/Screens/wrapper.dart';
import 'package:picture_msg/Screens/Home/profile.dart';
import 'Models/user.dart';
import 'firebase_options.dart';
import 'package:camera/camera.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}


class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(camera: camera),
        routes: {
          '/home': (context) =>  Home(camera: camera),
          '/profile': (context) => Profile(),
          '/chat' : (context) => RoomPage()
        },
      ),
    );
  }
}