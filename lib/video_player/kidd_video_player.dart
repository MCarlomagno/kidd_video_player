import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kidd_video_player/models/layout_configs.dart';
import 'package:kidd_video_player/video_controller_service/video_controller_service.dart';
import 'package:video_player/video_player.dart';
import 'full_screen.dart';
import 'layout.dart';

/// #### Main class in the package.
/// 
/// Use this class to show the video player as a child of some sized widget.
/// 
/// It recieves 4 parameters 
/// [videoFile] [videoUrl] [fromUrl] [layoutConfigs],
/// is important to use one and only one of the options __url__ or __file__, not both, not none of them.
/// 
/// see also: 
/// https://github.com/MCarlomagno/kidd_video_player

class KiddVideoPlayer extends StatefulWidget {

  /// The video source file.
  final File videoFile;

  /// The video source url.
  final String videoUrl;

  /// The value that indicates if the video source is an url or a File.
  final bool fromUrl;

  /// The class Layout config has the variables to customize the UI.
  final LayoutConfigs layoutConfigs;

  const KiddVideoPlayer({
    Key key,
    
    @required this.fromUrl,
    this.videoFile,
    this.videoUrl,
    this.layoutConfigs = LayoutConfigs.byDefault,
  }) : assert(fromUrl != null), assert(fromUrl && videoUrl != null || !fromUrl && videoFile != null), super(key: key);

  @override
  _KiddVideoPlayerState createState() => _KiddVideoPlayerState();
}

class _KiddVideoPlayerState extends State<KiddVideoPlayer> {

  /// Manages the state of the screen (full or not full screen).
  bool isFullScreen = false;

  /// The service that manages the video player controller.
  VideoControllerService _videoControllerService = VideoControllerService();

  /// True if the video player is not able to display video.
  bool isBusy = true;

  @override
  void initState() {
    super.initState();

    // creates controller
    _setController();

    // initializates controller
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: widget.layoutConfigs.backgroundColor,
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

  /// Builds the full screen widget, recieves the context and returns the widget.
  Widget _buildFullScreen(BuildContext context) {
    return FullScreen(
      backgroundColor: widget.layoutConfigs.backgroundColor,
      child: Layout(isFullScreen: isFullScreen, onFullScreen: onFullScreen, layoutConfigs: widget.layoutConfigs),
    );
  }

  /// The method called when the fullScreen button is pressed.
  /// Sets the orientation to landscape
  /// opens the full screen window and after the full screen widnow is 
  /// closed returns the normal screen orientation.
  void onFullScreen() async {
    _setLandscapeOrientation();
    isFullScreen = true;
    await _navigateToFullScreen();
    isFullScreen = false;
    _setFullOrientation();
  }

  /// Creates the VideoController for the given source (file or url).
  void _setController() {
    if (widget.fromUrl) {
      _videoControllerService.setController(VideoPlayerController.network(widget.videoUrl));
    } else {
      _videoControllerService.setController(VideoPlayerController.file(widget.videoFile));
    }
  }

  /// Initializes the VideoController and after initialization 
  /// sets [isBusy] on *false* to show the video player.
  void _initialize() {
    _videoControllerService.initializeController(inLoop: widget.layoutConfigs.inLoop).then((value) {
      setState(() {
        isBusy = false;
      });
    });
  }

  /// Sets the preferred device orientations to landscape only
  _setLandscapeOrientation() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  /// Sets the preferred device orientations to default
  _setFullOrientation() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ]);
  }

  /// Navigate to full screen page using navigator
  Future<void> _navigateToFullScreen() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return _buildFullScreen(context);
    }));
  }
}
