import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:picture_msg/Models/appUser.dart';



class DataBaseService {

  final String uid;
  DataBaseService( {required this.uid} );
  DataBaseService.withoutUID() : uid = "";
  //DataBaseService({required this.uid});


  //collection reference
  final CollectionReference userGroup = FirebaseFirestore.instance.collection('User');
  final CollectionReference groups = FirebaseFirestore.instance.collection('Groups');

  Future updateUserData(String email, String name, String age, String gender, String phoneNumber) async {
    return await userGroup.doc(uid).set({
      'email' : email,
      'name': name,
      'age': age,
      'gender' : gender,
      'phoneNumber': phoneNumber
    });
  }


  //get user list from snapshot
  List<AppUser> _myUserListFromSnapshot(QuerySnapshot snapshot) {
    try {
      return snapshot.docs.map((doc) {
        return AppUser(
          uid: doc.data().toString().contains('uid') ? doc.get('uid') : 'cannot find',
          name: doc.data().toString().contains('name') ? doc.get('name') : 'cannot find',
          age: doc.data().toString().contains('age') ? doc.get('age') : 'cannot find',
          email: doc.data().toString().contains('email') ? doc.get('email') : 'cannot find',
          gender: doc.data().toString().contains('gender') ? doc.get('gender') : 'cannot find',
          phoneNumber: doc.data().toString().contains('phoneNumber') ? doc.get('phoneNumber') : 'cannot find',
        );
      }).toList();
    } catch(e) {
      print(e.toString());
      return [];
    }
  }



  //getStream
  Stream<List<AppUser>> get user {
    return userGroup.snapshots()
        .map(_myUserListFromSnapshot);
  }

  Stream<List<AppUser>> get group {
    return groups.snapshots()
        .map(_myUserListFromSnapshot);
  }



}

