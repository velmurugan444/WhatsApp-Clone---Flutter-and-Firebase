import 'package:chatapplication/auth/login.dart';
import 'package:chatapplication/auth/models/contact.dart';
import 'package:chatapplication/auth/models/user_details.dart';
import 'package:chatapplication/screens/profile_screen.dart';
import 'package:chatapplication/screens/profile_viewer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CallScreen extends StatefulWidget {
  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();
    var userdata = Provider.of<Loginauthentication>(context, listen: false);
    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child("Registration");
    referenceData
        .orderByChild("username")
        .once()
        .then((DataSnapshot dataSnapshot) {
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
    DatabaseReference _ref;
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
                  return Consumer<Loginauthentication>(
                      builder: (context, data, child) {
                    return Form(
                      child: new Column(children: <Widget>[
                        SizedBox(
                          height: 15,
                        ),
                        new ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              String profile = contactList[index].profile;
                              String name = contactList[index].username;
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new ProfileViewer(
                                            name: name,
                                            profile: profile,
                                          )));
                            },
                            child: CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    NetworkImage(contactList[index].profile)),
                          ),
                          title: Row(children: <Widget>[
                            new Text(contactList[index].username,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold)),
                          ]),
                          trailing: GestureDetector(
                            onTap: () async {
                              _ref = FirebaseDatabase.instance
                                  .reference()
                                  .child(data.username);
                              String receivername = contactList[index].username;
                              String receiverimage = contactList[index].profile;
                              String receivermobile = contactList[index].mobile;
                              var now = new DateTime.now();
                              String formattedTime =
                                  DateFormat('kk:mm:a').format(now);
                              print(formattedTime);
                              String callername = data.username;
                              Map<String, dynamic> _data = {
                                "callername": callername,
                                "receivername": receivername,
                                "receiverimage": receiverimage,
                                "receivermobile": receivermobile,
                                "time": formattedTime
                              };
                              await _ref.push().set(_data);

                              String number = receivermobile;
                              final url = "tel:$number";
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            child: Icon(
                              Icons.phone,
                              color: Color(0xFF075e54),
                            ),
                          ),
                        ),
                      ]),
                    );
                  });
                },
              ));
  }
}
