
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:picture_msg/Models/appUser.dart';


class UserList extends StatefulWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<AppUser>>(context);
    //print(users.docs);
    users.forEach((user) {
      print("name: " + user.name);
      print("email: " + user.email);
      print("uid: " + user.uid);
      print("age: " + user.age);
      print("phone number: " + user.phoneNumber);

    });
    return Container(

    );
  }
}