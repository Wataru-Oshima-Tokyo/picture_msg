import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:picture_msg/Screens/Home/home.dart';
import 'dart:io';
import 'package:picture_msg/Chat/room_list_page.dart';

class chatRoom extends StatelessWidget{

  final Map<String, dynamic> userMap;
  final String roomID;

  chatRoom({required this.roomID, required this.userMap});

  final TextEditingController message = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void sendMSG() async{
    if(message.text.isNotEmpty) {
      Map<String, dynamic> MSG = {
        "sentby": auth.currentUser!.displayName,
        "message": message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      MSG.clear();
      await firestore
          .collection('chatroom')
          .doc(roomID)
          .collection('chats')
          .add(MSG);
    }else{
      print("meow");
    }
  }

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(userMap['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height /1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                  .collection('chatroom')
                  .doc(roomID).collection('chats')
                  .orderBy("time",descending: false)
                  .snapshots(),
                builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot){
                  if(snapshot.data != null){
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index){
                        Map<String, dynamic> map = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                        return MSG(size, map);
                      },
                    );
                  }else{
                      return Container();
                    }
                  },
                ),
              ),
            Container(
              height: size.height /10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height /17,
                width: size.width / 1.3,
                child: TextField(
                  controller: message,
                  decoration: InputDecoration(
                    hintText: "send message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(onPressed: sendMSG, icon: Icon(Icons.send)),
          ],
        ),
      ),
    );
  }
  Widget MSG(Size size, Map<String, dynamic> map){
    return Container(
      width: size.width,
      alignment: map['sentby'] == auth.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(),
        child: Text(map['message'], style: TextStyle(color: Colors.white),),
      ),
    );
  }
}