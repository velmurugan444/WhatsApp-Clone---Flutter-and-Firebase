import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class StatusDetailScreen extends StatefulWidget {
  final String profile;
  final String username;
  final String status;
  final String time;
  StatusDetailScreen({this.profile, this.username, this.status, this.time});
  @override
  _StatusDetailScreenState createState() => _StatusDetailScreenState();
}

class _StatusDetailScreenState extends State<StatusDetailScreen> {
  DatabaseReference _ref;
  TextEditingController _statustext = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.network(
                widget.status,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.black38,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: TextFormField(
                    controller: _statustext,
                    maxLines: 6,
                    minLines: 1,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.add_photo_alternate,
                          color: Colors.white,
                          size: 27,
                        ),
                        border: InputBorder.none,
                        hintText: "Add Caption....",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 17),
                        suffixIcon: CircleAvatar(
                          radius: 27,
                          backgroundColor: Colors.tealAccent[700],
                          child: IconButton(
                            onPressed: () async {
                              Map<String, String> _status = {
                                "profile": widget.profile,
                                "username": widget.username,
                                "status": widget.status,
                                "description": _statustext.text,
                                "time": widget.time,
                              };
                              _ref = FirebaseDatabase.instance
                                  .reference()
                                  .child("status");
                              await _ref.push().set(_status);
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                        )),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
