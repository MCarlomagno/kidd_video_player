import 'package:flutter/material.dart';
import 'package:kidd_video_player/kidd_video_player.dart';

class ExamplePage extends StatefulWidget {
  ExamplePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          child: KiddVideoPlayer(
            fromUrl: true,
            videoUrl: 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
          ),
        ),
      ),
    );
  }
}
