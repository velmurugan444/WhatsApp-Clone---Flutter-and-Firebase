import 'package:chatapplication/auth/models/contact.dart';
import 'package:chatapplication/auth/models/user_details.dart';
import 'package:chatapplication/screens/profile_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

// ignore: must_be_immutable
class Recentchats extends StatefulWidget {
  @override
  _RecentchatsState createState() => _RecentchatsState();
}

class _RecentchatsState extends State<Recentchats> {
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();
    var userdata = Provider.of<Loginauthentication>(context, listen: false);
    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child("Registration");
    referenceData
        .orderByChild("status")
        .equalTo("active")
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
    return InkWell(
      child: contactList.length == 0
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: contactList.length,
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    String profile = contactList[index].profile;
                    String name = contactList[index].username;
                    String mobile = contactList[index].mobile;
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new Chatpage(
                                profile: profile, name: name, mobile: mobile)));
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            String profile = contactList[index].profile;
                            String name = contactList[index].username;
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new ProfileViewer(
                                        profile: profile, name: name)));
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(contactList[index].profile),
                          ),
                        ),
                        title: Text(
                          contactList[index].username,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("chats")
                                .orderBy("time", descending: true)
                                .limit(1)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: Center(
                                        child: CircularProgressIndicator()));
                              } else {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot myPost =
                                          snapshot.data.documents[index];
                                      return Row(
                                        children: [
                                          Icon(Icons.done_all),
                                          SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            myPost['message'],
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Text(myPost['time'])
                                        ],
                                      );
                                    });
                              }
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 80),
                        child: Divider(
                          thickness: 1,
                        ),
                      )
                    ],
                  ),
                );
              }),
    );
  }
}
