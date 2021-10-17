import 'dart:io';
import 'package:chatapplication/auth/models/status.dart';
import 'package:chatapplication/screens/statusdetails_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:chatapplication/auth/models/user_details.dart';
import 'package:chatapplication/screens/storypageview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  List<Statusdata> contactList = [];
  File sampleImage;
  bool _visible = true;
  @override
  void initState() {
    var userdata = Provider.of<Loginauthentication>(context, listen: false);
    super.initState();
    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child("status");
    referenceData.orderByChild("time").once().then((DataSnapshot dataSnapshot) {
      contactList.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        Statusdata data = new Statusdata(
          values[key]['profile'],
          values[key]['username'],
          values[key]['status'],
          values[key]['description'],
          values[key]['time'],
        );
        if (!mounted) {
          return;
        } else {
          setState(() {
            contactList.add(data);
          });
          String user = data.username;
          if (user == userdata.username) {
            _visible = !_visible;
          } else {
            print("not exist");
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      // ignore: deprecated_member_use
      var tempImage = await ImagePicker.pickImage(source: ImageSource.camera);

      setState(() {
        sampleImage = tempImage;
        _visible = !_visible;
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
      body: Container(
        color: Color(0xfff2f2f2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: _visible,
              child: Card(
                color: Colors.white,
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<Loginauthentication>(
                      builder: (context, data, child) {
                    return ListTile(
                      leading: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(data.profile),
                          ),
                          Positioned(
                              bottom: 0.0,
                              right: 1.0,
                              child: Container(
                                height: 20,
                                width: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    getImage();
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle),
                              ))
                        ],
                      ),
                      title: Text(
                        "My Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Tap to add status update"),
                    );
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Recent updates",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ),
            Expanded(
                child: contactList.length == 0
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: contactList.length,
                        itemBuilder: (_, index) {
                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(contactList[index].profile),
                                ),
                                title: Text(
                                  contactList[index].username,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(contactList[index].time),
                                onTap: () {
                                  String image = contactList[index].status;
                                  String description =
                                      contactList[index].description;
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new StoryPageView(
                                                  image: image,
                                                  description: description)));
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 20, left: 80),
                                child: Divider(
                                  thickness: 1,
                                ),
                              )
                            ],
                          );
                        })),
          ],
        ),
      ),
    );
  }
}
