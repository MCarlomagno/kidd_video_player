import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kidd_video_player/video_controller_service/video_controller_service.dart';
import 'package:video_player/video_player.dart';

import 'full_screen.dart';
import 'layout.dart';

///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
///
///
///                      MAIN SCREEN!
///
///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class KiddVideoPlayer extends StatefulWidget {
  const KiddVideoPlayer({Key key, this.videoFile, this.videoUrl, @required this.fromUrl}) : super(key: key);
  final File videoFile;
  final String videoUrl;
  final bool fromUrl;

  @override
  _KiddVideoPlayerState createState() => _KiddVideoPlayerState();
}

class _KiddVideoPlayerState extends State<KiddVideoPlayer> {
  Widget _child;
  bool isFullScreen = false;
  VideoControllerService _videoControllerService = VideoControllerService();
  bool isBusy = true;

  @override
  void initState() {
    super.initState();
    if (widget.fromUrl) {
      _videoControllerService.setController(VideoPlayerController.network(widget.videoUrl));
    } else {
      _videoControllerService.setController(VideoPlayerController.file(widget.videoFile));
    }

    _videoControllerService.initializeController().then((value) {
      setState(() {
        isBusy = false;
      });
    });
    _child = Layout(
      isFullScreen: isFullScreen,
      onFullScreen: onFullScreen,
    );
  }

  void onFullScreen(videoPositionInMiliseconds) async {
    isFullScreen = true;

    videoPositionInMiliseconds = await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return FullScreen(
        child: Layout(
          isFullScreen: isFullScreen,
          videoPositionInMiliseconds: videoPositionInMiliseconds,
        ),
      );
    }));

    isFullScreen = false;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black,
      height: 500,
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      child: !isBusy
          ? _child
          : Center(
              child: CircularProgressIndicator(),
            ),
    ));
  }
}
