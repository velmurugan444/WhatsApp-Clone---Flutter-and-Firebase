import 'package:chatapplication/screens/contact_screen.dart';
import 'package:chatapplication/screens/recent_chats.dart';
import 'package:flutter/material.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Recentchats(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.message, color: Colors.white),
          onPressed: () {
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new ContactScreen()));
          },
        ));
  }
}
