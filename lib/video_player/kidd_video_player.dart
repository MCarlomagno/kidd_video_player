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
///                      KiddVideoPlayer!
///
///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class KiddVideoPlayer extends StatefulWidget {
  final File videoFile;

  final String videoUrl;

  final bool fromUrl;

  final bool showVolumeControl;

  final bool showVideoControl;

  final bool showFullScreenButton;

  final bool inLoop;

  final Color iconsColor;

  final Color sliderColor;

  final Color backgroundSliderColor;

  final Color backgroundColor;

  final Color loaderColor;

  final IconData pauseIcon;

  final IconData playIcon;

  const KiddVideoPlayer(
      {Key key,
      @required this.fromUrl,
      this.videoFile,
      this.videoUrl,
      this.showVolumeControl = true,
      this.showVideoControl = true,
      this.showFullScreenButton = true,
      this.inLoop = false,
      this.iconsColor = Colors.white,
      this.sliderColor = Colors.white,
      this.backgroundSliderColor = Colors.grey,
      this.backgroundColor = Colors.black,
      this.loaderColor = Colors.white,
      this.pauseIcon = Icons.pause,
      this.playIcon = Icons.play_arrow})
      : super(key: key);

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

    _videoControllerService.initializeController(inLoop: widget.inLoop).then((value) {
      setState(() {
        isBusy = false;
      });
    });
    _child = Layout(
      isFullScreen: isFullScreen,
      onFullScreen: onFullScreen,
      showVolumeControl: widget.showVolumeControl,
      showVideoControl: widget.showVideoControl,
      showFullScreenButton: widget.showFullScreenButton,
      iconsColor: widget.iconsColor,
      sliderColor: widget.sliderColor,
      backgroundSliderColor: widget.backgroundSliderColor,
      pauseIcon: widget.pauseIcon,
      playIcon: widget.playIcon,
    );
  }

  void onFullScreen(videoPositionInMiliseconds) async {
    isFullScreen = true;

    videoPositionInMiliseconds = await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return FullScreen(
        backgroundColor: widget.backgroundColor,
        child: Layout(
          isFullScreen: isFullScreen,
          onFullScreen: onFullScreen,
          showVolumeControl: widget.showVolumeControl,
          showVideoControl: widget.showVideoControl,
          showFullScreenButton: widget.showFullScreenButton,
          iconsColor: widget.iconsColor,
          sliderColor: widget.sliderColor,
          backgroundSliderColor: widget.backgroundSliderColor,
          pauseIcon: widget.pauseIcon,
          playIcon: widget.playIcon,
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
        color: widget.backgroundColor,
        height: 500,
        // Use a FutureBuilder to display a loading spinner while waiting for the
        // VideoPlayerController to finish initializing.
        child: !isBusy
            ? _child
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(widget.loaderColor),
                ),
              ),
      ),
    );
  }
}
