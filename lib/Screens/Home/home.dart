import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:picture_msg/Services/auth.dart';
import 'package:picture_msg/Screens/Home/profile.dart';
import 'package:picture_msg/Camera/camera.dart';
import 'package:picture_msg/Chat/room_list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:camera/camera.dart';


final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser!;
final String _uid = user.uid.toString();
final AuthService _auth = AuthService();

List storePayments =[];



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
    // var docRef = FirebaseFirestore.instance.collection('User').doc(_uid).snapshots().listen((docSnapshot) {
    //   if (docSnapshot.exists) {
    //     Map<String, dynamic> data = docSnapshot.data()!;
    //     storePayments = data['payments'];
    //     // print(storePayments);
    //   }
    // });
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Picture_msg',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout',
                style: TextStyle(
                color: Colors.red
              ),
              ),
              onPressed: ()async{
                await _auth.signOut();
              },
            )
          ],
        ),

        body: TabBarView(
          children: [
            Container(
              child: const HomeScreen(),
            ),
            Container(
              child: CameraApp(camera: camera),
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
                icon: Icon(Icons.camera),
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



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {

  final valueHolder = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}

