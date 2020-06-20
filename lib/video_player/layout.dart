import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kidd_video_player/video_controller_service/video_controller_service.dart';
import 'package:video_player/video_player.dart';

///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
///
///
///                      WIDGET SCREEN!
///
///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class Layout extends StatefulWidget {
  const Layout(
      {Key key,
      @required this.file,
      @required this.isFullScreen,
      this.onFullScreen,
      this.videoPositionInMiliseconds = 0})
      : super(key: key);
  final File file;
  final Function(int) onFullScreen;
  final bool isFullScreen;
  final int videoPositionInMiliseconds;

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  VideoControllerService _videoControllerService = VideoControllerService();

  Future<void> _initializeVideoPlayerFuture;
  Future<void> get initializeVideoPlayerFuture => this._initializeVideoPlayerFuture;

  // stream that listen the controller.position value
  StreamSubscription _streamSubscriptionToProgress;

  // video progress
  int _videoPositionInMiliseconds;

  // shows play/pause button and video progress
  bool _showControls = true;
  bool get showControls => this._showControls;

  // timer for hide controls
  Timer _timer;

  // if the user pressed mute, this variable record the last volume used
  double _lastVolume = 1.0;

  @override
  void initState() {
    super.initState();
    // Initialize the controller and store the Future for later use.
    _videoPositionInMiliseconds = widget.videoPositionInMiliseconds;
    //_onVideoPositionChanged(widget.videoPositionInMiliseconds);
  }

  @override
  Widget build(BuildContext context) {
    startStreaming();
    return Container(
      color: Colors.black,
      height: 500,
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              onTapScreen();
            },
            child: Container(
              color: Colors.black,
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
          Visibility(
            visible: _showControls,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          _videoControllerService.value.volume == 0.0 ? Icons.volume_off : Icons.volume_up,
                          size: 20,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _onVolumePressed();
                        },
                      ),
                      Slider(
                        inactiveColor: Colors.grey[400],
                        activeColor: Theme.of(context).accentColor,
                        onChanged: (val) {
                          _onVolumeChanged(val);
                        },
                        value: _videoControllerService.value.volume,
                        min: 0.0,
                        max: 1.0,
                      ),
                      Spacer(),
                      IconButton(
                          icon: Icon(
                            widget.isFullScreen ? Icons.close : Icons.crop_free,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (widget.isFullScreen) {
                              Navigator.pop(context, _videoPositionInMiliseconds);
                            } else {
                              widget.onFullScreen(_videoPositionInMiliseconds);
                            }
                          })
                    ],
                  ),
                ),
                Spacer(),
                _videoControllerService.controller != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _printDuration(Duration(milliseconds: _videoPositionInMiliseconds)),
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(_printDuration(_videoControllerService.value.duration),
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      )
                    : Container(),
                Slider(
                  inactiveColor: Colors.grey[400],
                  activeColor: Theme.of(context).accentColor,
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
              ],
            ),
          ),
          Visibility(
            visible: showControls,
            child: Center(
              child: IconButton(
                iconSize: 80,
                onPressed: () {
                  // Wrap the play or pause in a call to `setState`. This ensures the
                  // correct icon is shown.
                  _onPlayButtonPressed();
                },
                // Display the correct icon depending on the state of the player.
                icon: Icon(
                  _videoControllerService.value.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
                  color: Colors.white,
                ), // This trailing comma makes auto-formatting nicer for build methods.
              ),
            ),
          ),
        ],
      ),
    );
  }

  startStreaming() {
    this._videoControllerService.streamToProgress.listen((event) {
      if (_videoControllerService.value.duration.inMilliseconds.toDouble() > event.inMilliseconds.toDouble()) {
        setState(() {
          _videoPositionInMiliseconds = event.inMilliseconds;
        });
      }
    });
  }

  onTapScreen() {
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

  _onVolumePressed() {
    if (_videoControllerService.value.volume != 0) {
      _videoControllerService.setVolume(0.0);
    } else {
      _videoControllerService.setVolume(_lastVolume);
    }
  }

  _onPlayButtonPressed() {
    onTapScreen();
    // If the video is playing, pause it.
    if (_videoControllerService.value.isPlaying) {
      _videoControllerService.pauseVideo();
    } else {
      // If the video is paused, play it.
      _videoControllerService.playVideo();
    }
    setState(() {});
  }

  _onVideoPositionChanged(value) {
    onTapScreen();
    var duration = Duration(milliseconds: value.floor());
    _videoControllerService.seekTo(duration);
    if (_videoControllerService.value.duration.inMilliseconds.toDouble() > value.floor().toDouble()) {
      _videoPositionInMiliseconds = value.floor();
    }
    setState(() {});
  }

  _printDuration(Duration duration) {
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

  _onVolumeChanged(val) {
    _lastVolume = val;
    _videoControllerService.setVolume(val);
    onTapScreen();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    this._timer?.cancel();
    this._streamSubscriptionToProgress?.cancel();
    super.dispose();
  }
}