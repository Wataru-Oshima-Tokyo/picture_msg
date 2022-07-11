import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:picture_msg/Services/auth.dart';


final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser!;
final String _uid = user.uid.toString();
final AuthService _auth = AuthService();



class AddRoomPage extends StatefulWidget {
  AddRoomPage();

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddRoomPage> {
  String roomName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make a room'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Chatroom name'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    roomName = value;
                  });
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Post'),
                  onPressed: () async {
                    final date = DateTime.now().toLocal().toIso8601String();

                    await FirebaseFirestore.instance
                        .collection('chat_room')
                        .doc(_uid)
                        .set({
                      'name': roomName,
                      'createdAt': date,
                    });
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}