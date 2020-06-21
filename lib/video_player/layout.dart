import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kidd_video_player/models/layout_configs.dart';
import 'package:kidd_video_player/video_controller_service/video_controller_service.dart';
import 'package:video_player/video_player.dart';

/// #### Class that contains the most of the UI content.
/// 
/// Class for internal functionality proposes.
/// 
/// It recieves 4 parameters 
/// [onFullScreen] [isFullScreen] [videoPositionInMilliseconds] [layoutConfigs].
/// Only assertion [isFullScreen] != null.
/// 
/// see also: 
/// https://github.com/MCarlomagno/kidd_video_player

class Layout extends StatefulWidget {

  /// Callback to ancestor widget function to display this content on full screen.
  final Function onFullScreen;

  /// Flag in true when the video is playning on full screen.
  final bool isFullScreen;

  /// Progress in milliseconds of the current video.
  final int videoPositionInMilliseconds;

  /// Class that contains the UI customizations
  final LayoutConfigs layoutConfigs;

  const Layout({
    Key key,
    @required this.isFullScreen,
    this.onFullScreen,
    this.videoPositionInMilliseconds = 0,
    this.layoutConfigs = LayoutConfigs.byDefault,
  }) : assert(isFullScreen != null), super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {

  /// The service that manages the video player controller.
  VideoControllerService _videoControllerService = VideoControllerService();

  /// Progress in milliseconds of the current video.
  int _videoPositionInMiliseconds;

  /// shows play/pause button and video progress.
  bool _showControls = true;

  /// timer for hide controls after some duration.
  Timer _timer;

  /// If the user pressed mute, this variable record the last volume setted.
  double _lastVolume = 1.0;

  @override
  void initState() {
    super.initState();

    // initializates the variable with the value passed by parameter
    _videoPositionInMiliseconds = widget.videoPositionInMilliseconds;
  }

  @override
  Widget build(BuildContext context) {
    // starts the streaming for video progress
    startStreaming();

    return Container(
      /// three level stack with:
      /// 
      /// 1. Video display.
      /// 2. General controls.
      /// 3. Play/Pause button.
      child: Stack(
        children: <Widget>[
          // Video display.
          GestureDetector(
            onTap: () {
              onTapScreen();
            },
            child: Container(
              child: Center(
                child: AspectRatio(
                  aspectRatio: _videoControllerService.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: Hero(
                    tag: 'myTag',
                    child: VideoPlayer(_videoControllerService.controller),
                  ),
                ),
              ),
            ),
          ),

          // General Controls.
          Visibility(
            visible: _showControls,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Visibility(
                        visible: widget.layoutConfigs.showVolumeControl,
                        child: IconButton(
                          icon: Icon(
                            _videoControllerService.value.volume == 0.0 ? Icons.volume_off : Icons.volume_up,
                            size: 20,
                            color: widget.layoutConfigs.iconsColor,
                          ),
                          onPressed: () {
                            _onVolumePressed();
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.layoutConfigs.showVolumeControl,
                        child: Slider(
                          inactiveColor: widget.layoutConfigs.backgroundSliderColor,
                          activeColor: widget.layoutConfigs.sliderColor,
                          onChanged: (val) {
                            _onVolumeChanged(val);
                          },
                          value: _videoControllerService.value.volume,
                          min: 0.0,
                          max: 1.0,
                        ),
                      ),
                      Spacer(),
                      Visibility(
                        visible: widget.layoutConfigs.showFullScreenButton,
                        child: IconButton(
                          icon: Icon(
                            widget.isFullScreen ? Icons.close : Icons.crop_free,
                            color: widget.layoutConfigs.iconsColor,
                          ),
                          onPressed: () {
                            if (widget.isFullScreen) {
                              Navigator.pop(context, _videoPositionInMiliseconds);
                            } else {
                              widget.onFullScreen();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                _videoControllerService.controller != null
                    ? Visibility(
                        visible: widget.layoutConfigs.showVideoControl,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                _printDuration(Duration(milliseconds: _videoPositionInMiliseconds)),
                                style: TextStyle(color: widget.layoutConfigs.iconsColor),
                              ),
                              Text(_printDuration(_videoControllerService.value.duration),
                                  style: TextStyle(color: widget.layoutConfigs.iconsColor)),
                            ],
                          ),
                        ),
                      )
                    : Container(),
                Visibility(
                  visible: widget.layoutConfigs.showVideoControl,
                  child: Slider(
                    inactiveColor: widget.layoutConfigs.backgroundSliderColor,
                    activeColor: widget.layoutConfigs.sliderColor,
                    value: _videoPositionInMiliseconds.toDouble(),
                    onChanged: (value) {
                      _onVideoPositionChanged(value);
                    },
                    min: 0.0,
                    max: _videoControllerService.value.duration != null
                        ? _videoControllerService.value.duration.inMilliseconds.toDouble()
                        : _videoPositionInMiliseconds.toDouble(),
                    label: 'Video',
                  ),
                ),
              ],
            ),
          ),

          // Play/pause buttons
          Visibility(
            visible: _showControls,
            child: Center(
              child: IconButton(
                iconSize: 80,
                onPressed: () {
                  _onPlayButtonPressed();
                },
                icon: Icon(
                  _videoControllerService.value.isPlaying
                      ? widget.layoutConfigs.pauseIcon
                      : widget.layoutConfigs.playIcon,
                  color: widget.layoutConfigs.iconsColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// Starts listening a stream to [controller.progress] using the VideoControllerService.
  /// With this value updates the state of the [milliseconds] variable to show the progress 
  /// in the bottom slider.
  void startStreaming() {
    this._videoControllerService.streamToProgress.listen((event) {
      if (_videoControllerService.value.duration.inMilliseconds.toDouble() > event.inMilliseconds.toDouble()) {
        setState(() {
          _videoPositionInMiliseconds = event.inMilliseconds;
        });
      }
    });
  }

  /// Shows the controls when the user taps the screen and hides it after 3 seconds
  /// using a timer that it will refresh in every touch
  void onTapScreen() {
    if (_timer != null) {
      this._timer.cancel();
    }
    if (_showControls) {
      this._timer = Timer(const Duration(seconds: 3), () {
        setState(() {
          this._showControls = false;
        });
      });
    } else {
      setState(() {
        this._showControls = true;
      });
      this._timer = Timer(const Duration(seconds: 3), () {
        setState(() {
          this._showControls = false;
        });
      });
    }
  }

  /// Calls [onTapScreen()] to show the controls for 3 seconds more
  /// and in case of volume > 0 mute the video, 
  /// otherwise sets the last volume before it was muted
  void _onVolumePressed() {
    onTapScreen();
    if (_videoControllerService.value.volume != 0) {
      _videoControllerService.setVolume(0.0);
    } else {
      _videoControllerService.setVolume(_lastVolume);
    }
  }

  /// Calls [onTapScreen()] to show the controls for 3 seconds more
  /// and plays the video if it's paused or pauses the video if it's playing.
  void _onPlayButtonPressed() {
    onTapScreen();
    if (_videoControllerService.value.isPlaying) {
      _videoControllerService.pauseVideo();
    } else {
      _videoControllerService.playVideo();
    }
    setState(() {});
  }

  /// Calls [onTapScreen()] to show the controls for 3 seconds more
  /// and handles the slider dragging for move the current position of the video.
  void _onVideoPositionChanged(value) {
    onTapScreen();
    var duration = Duration(milliseconds: value.floor());
    _videoControllerService.seekTo(duration);
    if (_videoControllerService.value.duration.inMilliseconds.toDouble() > value.floor().toDouble()) {
      _videoPositionInMiliseconds = value.floor();
    }
    setState(() {});
  }

  /// Recieves a [duration] and returns the value printed in 
  /// __mm:ss__ format.
  String _printDuration(Duration duration) {
    if (duration != null) {
      String twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "00:00";
    }
  }

  /// Calls [onTapScreen()] to show the controls for 3 seconds more
  /// and handles the slider dragging for move the current video volume.
  void _onVolumeChanged(val) {
    _lastVolume = val;
    _videoControllerService.setVolume(val);
    onTapScreen();
  }

  @override
  void dispose() {
    // Disposes the timer.
    this._timer?.cancel();
    super.dispose();
  }
}
