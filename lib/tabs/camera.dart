import 'dart:io';
import 'package:chatapplication/screens/statusdetails_screen.dart';
import 'package:provider/provider.dart';
import 'package:chatapplication/auth/models/user_details.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  File sampleImage;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      // ignore: deprecated_member_use
      var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        sampleImage = tempImage;
      });
      final postImageRef =
          FirebaseStorage.instance.ref().child("status Images");

      var timeKey = DateTime.now();

      final StorageUploadTask uploadTask =
          postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      String url = imageUrl.toString();
      print("Image Url =" + url);
      var data = Provider.of<Loginauthentication>(context, listen: false);
      var profile = data.profile;
      var username = data.username;
      var now = new DateTime.now();
      String formattedTime = DateFormat('kk:mm:a').format(now);
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new StatusDetailScreen(
                  profile: profile,
                  username: username,
                  status: url,
                  time: formattedTime)));
    }

    return Scaffold(
        body: Center(
          child: Text("Update your status here"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera, color: Colors.white),
          onPressed: () {
            getImage();
          },
        ));
  }
}
