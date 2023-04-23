import 'dart:io';

import 'package:chatapp/Pages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadtoDatabase {
  File image;
  String fullname;
  UploadtoDatabase({required this.fullname, required this.image});

  uploadtoStorage(context) async {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user!.email;
    String uid = user.uid;
    TaskSnapshot emage = await uploadPhoto();
    Map<String, dynamic> mahesh = {
      'uid': uid,
      'email': email,
      'fullname': fullname,
      'profilepic': await emage.ref.getDownloadURL(),
    };
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(mahesh)
        .then((value) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HomePage();
      }));
    });
  }

  Future<TaskSnapshot> uploadPhoto() async {
    final storage = FirebaseStorage.instance;
    return await storage
        .ref('$fullname/${image.path.split('/').last}')
        .putFile(image);
  }
}
