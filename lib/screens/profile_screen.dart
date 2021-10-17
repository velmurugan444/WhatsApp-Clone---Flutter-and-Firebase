import 'dart:io';

import 'package:chatapplication/auth/models/user_details.dart';
import 'package:chatapplication/screens/profile_viewer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _aboutController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  File sampleImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Consumer<Loginauthentication>(builder: (context, data, child) {
        print(data.secretkey);
        print(data.userpassword);
        return Column(
          children: [
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                fit: StackFit.expand,
                // ignore: deprecated_member_use
                overflow: Overflow.visible,
                children: [
                  GestureDetector(
                    onTap: () {
                      String profile = data.profile;
                      String name = data.username;
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ProfileViewer(
                                    profile: profile,
                                    name: name,
                                  )));
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(data.profile),
                      minRadius: 50,
                      maxRadius: 75,
                    ),
                  ),
                  // ignore: deprecated_member_use
                  Positioned(
                      right: -12,
                      bottom: 0,
                      // ignore: deprecated_member_use
                      child: SizedBox(
                        height: 46,
                        width: 46,
                        // ignore: deprecated_member_use
                        child: FlatButton(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                                side: BorderSide(color: Colors.white)),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      height: 130,
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.camera_alt),
                                            title: Text("camera"),
                                            onTap: () async {
                                              // ignore: deprecated_member_use
                                              var tempImage =
                                                  // ignore: deprecated_member_use
                                                  await ImagePicker.pickImage(
                                                      source:
                                                          ImageSource.camera);
                                              setState(() {
                                                sampleImage = tempImage;
                                              });
                                              final postImageRef =
                                                  FirebaseStorage.instance
                                                      .ref()
                                                      .child("Profile Images");

                                              var timeKey = DateTime.now();

                                              final StorageUploadTask
                                                  uploadTask = postImageRef
                                                      .child(
                                                          timeKey.toString() +
                                                              ".jpg")
                                                      .putFile(sampleImage);
                                              var imageUrl =
                                                  await (await uploadTask
                                                          .onComplete)
                                                      .ref
                                                      .getDownloadURL();
                                              String url = imageUrl.toString();
                                              print("Image Url =" + url);
                                              String key = data.secretkey;
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child('Registration/' + key)
                                                  .set({
                                                'username': data.username,
                                                'profile': url,
                                                'mobile': data.mobile,
                                                'email': data.email,
                                                'password': data.userpassword,
                                                'address': data.address,
                                                'description': data.description,
                                                'status': data.status
                                              });
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(
                                                Icons.photo_album_outlined),
                                            title: Text("gallery"),
                                            onTap: () async {
                                              var tempImage =
                                                  // ignore: deprecated_member_use
                                                  await ImagePicker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              setState(() {
                                                sampleImage = tempImage;
                                              });
                                              final postImageRef =
                                                  FirebaseStorage.instance
                                                      .ref()
                                                      .child("Profile Images");

                                              var timeKey = DateTime.now();

                                              final StorageUploadTask
                                                  uploadTask = postImageRef
                                                      .child(
                                                          timeKey.toString() +
                                                              ".jpg")
                                                      .putFile(sampleImage);
                                              var imageUrl =
                                                  await (await uploadTask
                                                          .onComplete)
                                                      .ref
                                                      .getDownloadURL();
                                              String url = imageUrl.toString();
                                              print("Image Url =" + url);
                                              String key = data.secretkey;
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child('Registration/' + key)
                                                  .set({
                                                'username': data.username,
                                                'profile': url,
                                                'mobile': data.mobile,
                                                'email': data.email,
                                                'password': data.userpassword,
                                                'address': data.address,
                                                'description': data.description,
                                                'status': data.status
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            color: Color(0xff25d366),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            )),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // ignore: deprecated_member_use
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // ignore: deprecated_member_use
              child: FlatButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            child: Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Enter your name"),
                                    subtitle: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 26.0),
                                      child: TextFormField(
                                        autofocus: true,
                                        controller: _nameController,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("cancel")),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              String key = data.secretkey;
                                              String name =
                                                  _nameController.text;

                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child('Registration/' + key)
                                                  .set({
                                                'username': name,
                                                'profile': data.profile,
                                                'mobile': data.mobile,
                                                'email': data.email,
                                                'password': data.userpassword,
                                                'address': data.address,
                                                'description': data.description,
                                                'status': data.status
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text("save"))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Color(0xFFF5F6F9),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.supervisor_account_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        data.username,
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                      Icon(Icons.edit)
                    ],
                  )),
            ),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                // ignore: deprecated_member_use
                child: FlatButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Container(
                              child: Padding(
                                padding: MediaQuery.of(context).viewInsets,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      title: Text("Add About"),
                                      subtitle: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 26.0),
                                        child: TextFormField(
                                          autofocus: true,
                                          controller: _aboutController,
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () {},
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("cancel")),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                String key = data.secretkey;
                                                String description =
                                                    _aboutController.text;

                                                FirebaseDatabase.instance
                                                    .reference()
                                                    .child(
                                                        'Registration/' + key)
                                                    .set({
                                                  'username': data.username,
                                                  'profile': data.profile,
                                                  'mobile': data.mobile,
                                                  'email': data.email,
                                                  'password': data.userpassword,
                                                  'address': data.address,
                                                  'description': description,
                                                  'status': data.status
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Text("save"))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color(0xFFF5F6F9),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                            child: Text(
                          data.description ?? 'no description',
                          style: Theme.of(context).textTheme.bodyText1,
                        )),
                        Icon(Icons.edit)
                      ],
                    )),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // ignore: deprecated_member_use
              child: FlatButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            child: Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Add Address"),
                                    subtitle: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 26.0),
                                      child: TextFormField(
                                        autofocus: true,
                                        controller: _addressController,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("cancel")),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              String key = data.secretkey;
                                              String address =
                                                  _addressController.text;

                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child('Registration/' + key)
                                                  .set({
                                                'username': data.username,
                                                'profile': data.profile,
                                                'mobile': data.mobile,
                                                'email': data.email,
                                                'password': data.userpassword,
                                                'address': address,
                                                'description': data.description,
                                                'status': data.status
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text("save"))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Color(0xFFF5F6F9),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.drive_eta_outlined,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        data.address,
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                      Icon(Icons.edit)
                    ],
                  )),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              // ignore: deprecated_member_use
              child: FlatButton(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return Container(
                            child: Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    title: Text("Add Mobile"),
                                    subtitle: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 26.0),
                                      child: TextFormField(
                                        autofocus: true,
                                        controller: _mobileController,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text("cancel")),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              String key = data.secretkey;
                                              String mobile =
                                                  _mobileController.text;

                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child('Registration/' + key)
                                                  .set({
                                                'username': data.username,
                                                'profile': data.profile,
                                                'mobile': mobile,
                                                'email': data.email,
                                                'password': data.userpassword,
                                                'address': data.address,
                                                'description': data.description,
                                                'status': data.status
                                              });

                                              Navigator.pop(context);
                                            },
                                            child: Text("save"))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  padding: EdgeInsets.all(20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  color: Color(0xFFF5F6F9),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.phone,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        data.mobile,
                        style: Theme.of(context).textTheme.bodyText1,
                      )),
                      Icon(Icons.edit)
                    ],
                  )),
            ),
          ],
        );
      }),
    );
  }
}
