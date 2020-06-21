import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kidd_video_player/models/layout_configs.dart';
import 'package:kidd_video_player/video_controller_service/video_controller_service.dart';
import 'package:video_player/video_player.dart';
import 'full_screen.dart';
import 'layout.dart';

class KiddVideoPlayer extends StatefulWidget {
  final File videoFile;

  final String videoUrl;

  final bool fromUrl;

  final LayoutConfigs layoutConfigs;

  const KiddVideoPlayer({
    Key key,
    @required this.fromUrl,
    this.videoFile,
    this.videoUrl,
    this.layoutConfigs = LayoutConfigs.byDefault,
  }) : super(key: key);

  @override
  _KiddVideoPlayerState createState() => _KiddVideoPlayerState();
}

class _KiddVideoPlayerState extends State<KiddVideoPlayer> {
  bool isFullScreen = false;
  VideoControllerService _videoControllerService = VideoControllerService();
  bool isBusy = true;

  @override
  void initState() {
    super.initState();
    _setController();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: widget.layoutConfigs.backgroundColor,
        height: 500,
        child: !isBusy
            ? Layout(isFullScreen: isFullScreen, onFullScreen: onFullScreen, layoutConfigs: widget.layoutConfigs)
            : Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(widget.layoutConfigs.loaderColor),
                ),
              ),
      ),
    );
  }

  Widget _buildFullScreen(BuildContext context) {
    return FullScreen(
      backgroundColor: widget.layoutConfigs.backgroundColor,
      child: Layout(isFullScreen: isFullScreen, onFullScreen: onFullScreen, layoutConfigs: widget.layoutConfigs),
    );
  }

  void onFullScreen(videoPositionInMiliseconds) async {
    _setLandscapeOrientation();
    isFullScreen = true;
    await _navigateToFullScreen();
    isFullScreen = false;
    _setFullOrientation();
  }

  _setController() {
    if (widget.fromUrl) {
      _videoControllerService.setController(VideoPlayerController.network(widget.videoUrl));
    } else {
      _videoControllerService.setController(VideoPlayerController.file(widget.videoFile));
    }
  }

  _initialize() {
    _videoControllerService.initializeController(inLoop: widget.layoutConfigs.inLoop).then((value) {
      setState(() {
        isBusy = false;
      });
    });
  }

  _setLandscapeOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  _setFullOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }

  Future<void> _navigateToFullScreen() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return _buildFullScreen(context);
    }));
  }
}
