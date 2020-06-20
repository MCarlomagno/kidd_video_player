import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
///
///
///                      WIDGET SCREEN!
///
///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class KiddVideoPlayer extends StatefulWidget {
  const KiddVideoPlayer(
      {Key key, @required this.file, @required this.isFullScreen, @required this.controller, this.onFullScreen})
      : super(key: key);
  final File file;
  final VoidCallback onFullScreen;
  final bool isFullScreen;
  final VideoPlayerController controller;

  @override
  _KiddVideoPlayerState createState() => _KiddVideoPlayerState();
}

class _KiddVideoPlayerState extends State<KiddVideoPlayer> {

  Future<void> _initializeVideoPlayerFuture;
  Future<void> get initializeVideoPlayerFuture => this._initializeVideoPlayerFuture;

  // stream that listen the controller.position value
  Stream<Duration> _streamToProgress;
  StreamSubscription _streamSubscriptionToProgress;

  // video progress
  int _videoPositionInMiliseconds = 0;
  int get videoPositionInMiliseconds => this._videoPositionInMiliseconds;

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
                  aspectRatio: widget.controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: Hero(
                    tag: 'myTag',
                    child: VideoPlayer(widget.controller),
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
                          widget.controller.value.volume == 0.0 ? Icons.volume_off : Icons.volume_up,
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
                        value: widget.controller.value.volume,
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
                              Navigator.pop(context);
                            } else {
                              widget.onFullScreen();
                            }
                          })
                    ],
                  ),
                ),
                Spacer(),
                widget.controller != null
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              _printDuration(Duration(milliseconds: videoPositionInMiliseconds)),
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(_printDuration(widget.controller.value.duration),
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      )
                    : Container(),
                Slider(
                  inactiveColor: Colors.grey[400],
                  activeColor: Theme.of(context).accentColor,
                  value: videoPositionInMiliseconds.toDouble(),
                  onChanged: (value) {
                    _onVideoPositionChanged(value);
                  },
                  min: 0.0,
                  max: widget.controller.value.duration != null
                      ? widget.controller.value.duration.inMilliseconds.toDouble()
                      : 0,
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
                  widget.controller.value.isPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline,
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
    _streamToProgress = this.widget.controller.position.asStream();
    _streamSubscriptionToProgress = _streamToProgress.listen((event) {
      if (widget.controller.value.duration.inMilliseconds.toDouble() > event.inMilliseconds.toDouble()) {
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
    if (widget.controller.value.volume != 0) {
      widget.controller.setVolume(0.0);
    } else {
      widget.controller.setVolume(_lastVolume);
    }
  }

  _onPlayButtonPressed() {
    onTapScreen();
    // If the video is playing, pause it.
    if (widget.controller.value.isPlaying) {
      widget.controller.pause();
    } else {
      // If the video is paused, play it.
      widget.controller.play();
    }
    setState(() {});
  }

  _onVideoPositionChanged(value) {
    onTapScreen();
    var duration = Duration(milliseconds: value.floor());
    widget.controller.seekTo(duration);
    if (widget.controller.value.duration.inMilliseconds.toDouble() > value.floor().toDouble()) {
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
    widget.controller.setVolume(val);
    onTapScreen();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    this._timer.cancel();
    this._streamSubscriptionToProgress.cancel();
    super.dispose();
  }
}

///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
///
///
///                      MAIN SCREEN!
///
///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class MainScreen extends StatefulWidget {
  const MainScreen({Key key, @required this.file}) : super(key: key);
  final File file;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _child;
  bool isFullScreen = false;
  bool _isBusy = true;

  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file);
    // Initialize the controller and store the Future for later use.
    _controller.initialize().then((value) {
      // Use the controller to loop the video.
      _controller.setLooping(false);
      setState(() {
        _isBusy = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onFullScreen() {
    isFullScreen = true;
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return _isBusy
          ? DetailScreen(
              child: KiddVideoPlayer(
                file: widget.file,
                isFullScreen: isFullScreen,
                controller: _controller,
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            );
    }));
  }

  @override
  Widget build(BuildContext context) {
    _child = KiddVideoPlayer(
      file: widget.file,
      isFullScreen: isFullScreen,
      onFullScreen: onFullScreen,
      controller: _controller,
    );
    return Scaffold(
        body: Container(
      color: Colors.black,
      height: 500,
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      child: _child,
    ));
  }
}

///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
///
///
///                      DETAIL SCREEN!
///
///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key key, @required this.child}) : super(key: key);
  final Widget child;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
    );
  }
}
