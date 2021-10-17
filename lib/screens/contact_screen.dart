import 'package:chatapplication/auth/login.dart';
import 'package:chatapplication/auth/models/contact.dart';
import 'package:chatapplication/auth/models/user_details.dart';
import 'package:chatapplication/screens/profile_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_page.dart';

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();
    var userdata = Provider.of<Loginauthentication>(context, listen: false);
    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child("Registration");
    referenceData.once().then((DataSnapshot dataSnapshot) {
      contactList.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        Contact data = new Contact(
          values[key]['profile'],
          values[key]['username'],
          values[key]['description'],
          values[key]['email'],
          values[key]['password'],
          values[key]['address'],
          values[key]['mobile'],
        );
        if (!mounted) {
          return;
        } else {
          setState(() {
            contactList.add(data);
          });
          contactList.removeWhere((item) => item.username == userdata.username);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select contact"),
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            PopupMenuButton<String>(onSelected: (value) {
              if (value == "Clear call log") {
                var data =
                    Provider.of<Loginauthentication>(context, listen: false);
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
          ],
        ),
        body: contactList.length == 0
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (_, index) {
                  return new Column(children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () {
                        String profile = contactList[index].profile;
                        String name = contactList[index].username;
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => new Chatpage(
                                    profile: profile, name: name)));
                      },
                      child: new ListTile(
                        leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(contactList[index].profile)),
                        title: Row(children: <Widget>[
                          new Text(contactList[index].username,
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold))
                        ]),
                      ),
                    )
                  ]);
                },
              ));
  }
}
