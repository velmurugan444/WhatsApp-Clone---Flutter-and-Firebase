import 'package:chatapplication/auth/models/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class Chatpage extends StatefulWidget {
  final String profile;
  final String name;
  final String mobile;
  Chatpage({this.profile, this.name, this.mobile});
  @override
  _ChatpageState createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  bool show = false;
  FocusNode _focusNode = FocusNode();
  TextEditingController _controller = TextEditingController();
  DatabaseReference _ref;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  Widget senderCard() {
    return Consumer<Loginauthentication>(builder: (context, data, child) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(child: CircularProgressIndicator()));
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot myPost = snapshot.data.documents[index];
                  return Align(
                    alignment: myPost['sender'] == data.username
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 45),
                      child: Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        margin:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        color: myPost['sender'] == data.username
                            ? Color(0xffdcf8c6)
                            : Colors.white,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 60, top: 5, bottom: 20),
                              child: Text(
                                myPost['message'],
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Positioned(
                              bottom: 4,
                              right: 10,
                              child: Row(
                                children: [
                                  Text(
                                    myPost['time'],
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.grey[600]),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.done_all,
                                    size: 20,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/images/chat.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leadingWidth: 70,
            leading: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 24,
                  ),
                ),
                SizedBox(width: 2.0),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blueGrey,
                  backgroundImage: NetworkImage(widget.profile),
                )
              ],
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(fontSize: 18.5, fontWeight: FontWeight.bold),
                )
              ],
            ),
            actions: [
              Consumer<Loginauthentication>(builder: (context, data, child) {
                return IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () async {
                      _ref = FirebaseDatabase.instance
                          .reference()
                          .child(data.username);
                      String receivername = widget.name;
                      String receiverimage = widget.profile;
                      var now = new DateTime.now();
                      String receivermobile = widget.mobile;
                      String formattedTime = DateFormat('kk:mm:a').format(now);
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

                      String number = widget.mobile;
                      final url = "tel:$number";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    });
              })
            ],
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: WillPopScope(
                child: Stack(children: [
                  Container(
                    height: MediaQuery.of(context).size.height - 145,
                    child: ListView(
                      children: [
                        senderCard(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 55,
                            child: Card(
                                margin: EdgeInsets.only(
                                    left: 2, right: 2, bottom: 8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                child: TextFormField(
                                  controller: _controller,
                                  focusNode: _focusNode,
                                  keyboardType: TextInputType.multiline,
                                  textAlignVertical: TextAlignVertical.center,
                                  maxLines: 5,
                                  minLines: 1,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: IconButton(
                                      icon: Icon(Icons.emoji_emotions),
                                      onPressed: () {
                                        _focusNode.unfocus();
                                        _focusNode.canRequestFocus = false;
                                        setState(() {
                                          show = !show;
                                        });
                                      },
                                    ),
                                    hintText: "Type a message",
                                    contentPadding: EdgeInsets.all(5),
                                  ),
                                )),
                          ),
                          Consumer<Loginauthentication>(
                              builder: (context, data, child) {
                            return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, right: 2),
                                child: CircleAvatar(
                                    backgroundColor: Color(0xFF128C7E),
                                    radius: 25,
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.send,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          String sender = data.username;
                                          String key = data.secretkey;
                                          String receiver = widget.name;
                                          var now = new DateTime.now();
                                          String formattedTime =
                                              DateFormat('kk:mm:a').format(now);

                                          Map<String, dynamic> _data = {
                                            "sender": sender,
                                            "message": _controller.text,
                                            "time": formattedTime,
                                            "receiver": receiver
                                          };
                                          FirebaseFirestore.instance
                                              .collection("chats")
                                              .add(_data);
                                          _controller.text = "";

                                          FirebaseDatabase.instance
                                              .reference()
                                              .child('Registration/' + key)
                                              .set({
                                            'username': data.username,
                                            'profile': data.profile,
                                            'mobile': data.mobile,
                                            'email': data.email,
                                            'password': data.userpassword,
                                            'address': data.address,
                                            'description': data.description,
                                            'status': "active",
                                          });

                                          DatabaseReference db =
                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child("Registration");
                                          db
                                              .orderByChild("username")
                                              .equalTo(widget.name)
                                              .once()
                                              .then((DataSnapshot snapshot) {
                                            Map<dynamic, dynamic> values =
                                                snapshot.value;
                                            values.forEach((key, values) {
                                              print(values["profile"]);
                                              print(values["username"]);
                                              print(values["email"]);
                                              print(values["password"]);
                                              print(values["address"]);
                                              print(values["description"]);
                                              print(values["mobile"]);
                                              print(values["status"]);
                                              print(key);
                                              String receiverkey = key;
                                              String receiverprofile =
                                                  values["profile"];
                                              String receiverusername =
                                                  values["username"];
                                              String receiveremail =
                                                  values["email"];
                                              String receiverpassword =
                                                  values["password"];
                                              String receiverdescription =
                                                  values["description"];
                                              String receiveraddress =
                                                  values["address"];
                                              String receivermobile =
                                                  values["mobile"];

                                              FirebaseDatabase.instance
                                                  .reference()
                                                  .child('Registration/' +
                                                      receiverkey)
                                                  .set({
                                                'username': receiverusername,
                                                'profile': receiverprofile,
                                                'mobile': receivermobile,
                                                'email': receiveremail,
                                                'password': receiverpassword,
                                                'address': receiveraddress,
                                                'description':
                                                    receiverdescription,
                                                'status': "active",
                                              });
                                            });
                                          });
                                        })));
                          })
                        ]),
                        show ? emojiPicker() : Container()
                      ],
                    ),
                  ),
                ]),
                onWillPop: () {
                  if (show) {
                    setState(() {
                      show = false;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                  return Future.value(false);
                }),
          ),
        ),
      ],
    );
  }

  Widget emojiPicker() {
    return EmojiPicker(
        rows: 4,
        columns: 7,
        onEmojiSelected: (emoji, category) {
          print(emoji);
          _controller.text = _controller.text + emoji.emoji;
        });
  }
}
