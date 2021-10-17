import 'package:flutter/material.dart';

class ProfileViewer extends StatefulWidget {
  final String profile;
  final String name;
  ProfileViewer({this.profile, this.name});

  @override
  _ProfileViewerState createState() => _ProfileViewerState();
}

class _ProfileViewerState extends State<ProfileViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Center(
        child: Container(
            alignment: Alignment.center,
            child: Image.network(
              widget.profile,
              fit: BoxFit.fill,
            )),
      ),
    );
  }
}
