import 'package:flutter/material.dart';
import 'package:flutter_whatsapp_clone2/common/widgets/loader.dart';
import 'package:flutter_whatsapp_clone2/models/status_model.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class StatusScreen extends StatefulWidget {
  static const String routeName = '/status-screen';
  final Status status;
  const StatusScreen({super.key, required this.status});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  StoryController controller = StoryController();
  List<StoryItem> storyItems = [];

  void initStoryPageItems() {
    for (int i = 0; i < widget.status.photoUrl.length; i++) {
      storyItems.add(
        StoryItem.pageImage(
            url: widget.status.photoUrl[i], controller: controller),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    initStoryPageItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItems.isEmpty
          ? const Loader()
          : StoryView(
              storyItems: storyItems,
              controller: controller,
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.of(context).pop();
                }
              },
            ),
    );
  }
}
