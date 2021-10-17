import 'package:chatapplication/auth/models/callhistory.dart';
import 'package:chatapplication/auth/models/user_details.dart';
import 'package:chatapplication/screens/call_screen.dart';
import 'package:chatapplication/screens/profile_viewer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Calls extends StatefulWidget {
  @override
  _CallsState createState() => _CallsState();
}

class _CallsState extends State<Calls> {
  List<Callhistory> contactList = [];

  @override
  void initState() {
    super.initState();
    var data = Provider.of<Loginauthentication>(context, listen: false);
    DatabaseReference referenceData =
        FirebaseDatabase.instance.reference().child(data.username);

    referenceData
        .orderByChild("callername")
        .equalTo(data.username)
        .once()
        .then((DataSnapshot dataSnapshot) {
      contactList.clear();
      var keys = dataSnapshot.value.keys;
      var values = dataSnapshot.value;

      for (var key in keys) {
        Callhistory data = new Callhistory(
          values[key]['receiverimage'],
          values[key]['receivername'],
          values[key]['receivermobile'],
          values[key]['time'],
        );
        if (!mounted) {
          return;
        } else {
          setState(() {
            contactList.add(data);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference _ref;
    return Scaffold(
        body: contactList.length == 0
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (_, index) {
                  return Consumer<Loginauthentication>(
                      builder: (context, data, child) {
                    return Form(
                      child: new Column(children: <Widget>[
                        new ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              String profile = contactList[index].receiverimage;
                              String name = contactList[index].receivername;
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
                                backgroundImage: NetworkImage(
                                    contactList[index].receiverimage)),
                          ),
                          title: Row(children: <Widget>[
                            new Text(contactList[index].receivername,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold)),
                          ]),
                          subtitle: Text(contactList[index].time),
                          trailing: GestureDetector(
                            onTap: () async {
                              _ref = FirebaseDatabase.instance
                                  .reference()
                                  .child("outgoingcalls");
                              String receivername =
                                  contactList[index].receivername;
                              String receiverimage =
                                  contactList[index].receiverimage;
                              var now = new DateTime.now();
                              String receivermobile =
                                  contactList[index].receivermobile;
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
                        Padding(
                          padding: const EdgeInsets.only(right: 20, left: 80),
                          child: Divider(
                            thickness: 1,
                          ),
                        )
                      ]),
                    );
                  });
                },
              ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_call, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new CallScreen()));
          },
        ));
  }
}
