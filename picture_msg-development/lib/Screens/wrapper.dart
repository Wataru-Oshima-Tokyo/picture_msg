import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:picture_msg/Models/user.dart';
import 'package:picture_msg/Screens/Authenticate/authenticate.dart';
import 'package:picture_msg/Screens/Home/home.dart';
import 'package:camera/camera.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    //return home authenticate
    if(user == null){
      return Authenticate();
    }
    else{
      return Home(camera: camera);
    }
  }
}