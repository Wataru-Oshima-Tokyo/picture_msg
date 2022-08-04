import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:picture_msg/Chat/ChatRoom.dart';
import 'dart:async';
import 'package:picture_msg/Screens/Home/home.dart';
import 'package:provider/provider.dart';


class RoomPage extends StatefulWidget{
  @override
  RoomListPage createState() => RoomListPage();
}
class RoomListPage extends State<RoomPage> {
  // 引数からユーザー情報を受け取れるようにする
  Map <String , dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController search = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String chatRoomID(String user1, String user2){
    if(user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }else{
      return "$user2$user1";
    }
  }

  void onSearch() async{//allows us to search for users
    setState(() {
      isLoading = true;
    });

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    await firestore.collection('User').where("email", isEqualTo: search.text)
    .get().then((value){
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: isLoading
          ? Center(
        child: Container(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(),
        ),
      )
      : Column(
        children: [
          TextField(
            controller: search,
            decoration: InputDecoration(
              hintText: "SEARCH for a user",
            ),
          ),
          ElevatedButton(
            onPressed: onSearch,
            child: Text("Search"),
          ),
          userMap != null ? ListTile(
            onTap: (){
              String ID = chatRoomID(
                auth.currentUser!.displayName!,
                userMap!['name']);
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => chatRoom(
                roomID: ID,
                userMap: userMap!,
              )));
            },
            trailing: Icon(Icons.chat_bubble, color: Colors.black),
            title: Text(userMap!['name']),
            subtitle: Text(userMap!['email']),
          ): Container(),
        ],
      ),

    );
  }
}