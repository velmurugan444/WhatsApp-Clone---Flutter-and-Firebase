import 'dart:io';
import 'package:chatapplication/screens/profile_screen.dart';
import 'package:intl/intl.dart';
import 'package:chatapplication/auth/login.dart';
import 'package:chatapplication/auth/models/user_details.dart';
import 'package:chatapplication/screens/statusdetails_screen.dart';
import 'package:chatapplication/tabs/calls.dart';
import 'package:chatapplication/tabs/camera.dart';
import 'package:chatapplication/tabs/chats.dart';
import 'package:chatapplication/tabs/status.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  File sampleImage;
  TabController _tabController;
  bool _isSearching = false;
  bool _icon = false;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this, initialIndex: 1);
  }

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
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: !_isSearching
              ? Text("WhatsApp Clone")
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: TextField(
                    decoration: InputDecoration(
                        hoverColor: Color(0xff075e54),
                        icon: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => ChatScreen()));
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                ),
          actions: [
            _isSearching
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _icon = !_icon;
                      });
                    })
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                        _icon = !_icon;
                      });
                    }),
            !_icon
                ? PopupMenuButton<String>(onSelected: (value) {
                    if (value == "Clear call log") {
                      var data = Provider.of<Loginauthentication>(context,
                          listen: false);
                      FirebaseDatabase.instance
                          .reference()
                          .child(data.username)
                          .remove();
                    } else if (value == "Logout") {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new LoginPage()));
                    } else if (value == "Settings") {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ProfileScreen()));
                    }
                  }, itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        child: Text("Clear call log"),
                        value: "Clear call log",
                      ),
                      PopupMenuItem(
                        child: Text("Settings"),
                        value: "Settings",
                      ),
                      PopupMenuItem(
                        child: Text("Logout"),
                        value: "Logout",
                      ),
                    ];
                  })
                : Text(""),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            controller: _tabController,
            tabs: [
              GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: Tab(icon: Icon(Icons.camera_alt))),
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS')
            ],
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: <Widget>[Camera(), Chat(), Status(), Calls()]));
  }
}
