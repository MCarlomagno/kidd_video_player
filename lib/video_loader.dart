library kidd_video_player;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kidd_video_player/video_player.dart';

class VideoLoader extends StatefulWidget {
  const VideoLoader({Key key}) : super(key: key);

  @override
  _VideoLoaderState createState() => _VideoLoaderState();
}

class _VideoLoaderState extends State<VideoLoader> {
  bool _videoLoaded = false;
  bool _videoPlayerOpened = false;
  File _videoFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
           _addVideoWidget(),
           _videoPlayerWidget(),
        ],
      ),
    );
  }

  Widget _addVideoWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _videoFromGalleryWidget(),
            SizedBox(
              width: 10,
            ),
            _videoFromCameraWidget()
          ],
        ),
      ),
    );
  }

  Widget _videoFromGalleryWidget() {
    return RaisedButton(
      child: Padding(
        child: Icon(
          Icons.file_upload,
          size: 50,
        ),
        padding: EdgeInsets.all(20.0),
      ),
      shape: CircleBorder(
        side: BorderSide(color: Colors.white),
      ),
      color: Colors.transparent,
      onPressed: () {
        getVideoFromGallery();
      },
    );
  }

  Widget _videoFromCameraWidget() {
    return RaisedButton(
      child: Padding(
        child: Icon(
          Icons.videocam,
          size: 50,
        ),
        padding: EdgeInsets.all(20.0),
      ),
      shape: CircleBorder(
        side: BorderSide(color: Colors.white),
      ),
      color: Colors.transparent,
      onPressed: () {
        getVideoFromCamera();
      },
    );
  }

  Widget _videoPlayerWidget() {
    return Container();
    //  Visibility(
    //   visible: _videoLoaded && _videoPlayerOpened,
    //   child: KiddVideoPlayer(
    //     file: _videoFile,
    //   ),
    // );
  }

  getVideoFromGallery() {}

  getVideoFromCamera() {}
}
