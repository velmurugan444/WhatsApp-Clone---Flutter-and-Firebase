import 'package:flutter/material.dart';
import 'package:story_view/story_controller.dart';
import 'package:story_view/story_view.dart';

class StoryPageView extends StatefulWidget {
  final String image;
  final String description;
  StoryPageView({this.image, this.description});

  @override
  _StoryPageViewState createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  @override
  Widget build(BuildContext context) {
    final controller = StoryController();
    final List<StoryItem> storyItems = [
      StoryItem.text("Welcome to Startup_Projects", Colors.red),
      StoryItem.pageImage(NetworkImage(widget.image),
          caption: widget.description),
    ];
    return Material(
      child: StoryView(
        storyItems,
        controller: controller,
        inline: false,
        repeat: false,
      ),
    );
  }
}
