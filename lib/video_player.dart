import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class KiddVideoPlayer extends StatefulWidget {
  const KiddVideoPlayer({Key key, @required this.file}) : super(key: key);
  final File file;

  @override
  _KiddVideoPlayerState createState() => _KiddVideoPlayerState();
}

class _KiddVideoPlayerState extends State<KiddVideoPlayer> {
  bool _isBusy = true;
  // Video player controller
  VideoPlayerController _controller;
  VideoPlayerController get controller => this._controller;

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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: MediaQuery.of(context).orientation == Orientation.landscape
          ? MediaQuery.of(context).size.height * 0.8
          : MediaQuery.of(context).size.height * 0.5,
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      child: Stack(
        children: <Widget>[
          Visibility(
            visible: !_isBusy,
            child: GestureDetector(
              onTap: () {
                onTapScreen();
              },
              child: Container(
                color: Colors.black,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
              visible: _isBusy,
              child: Center(
                child: CircularProgressIndicator(),
              )),
          Visibility(
            visible: !_isBusy && _showControls,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          _controller.value.volume == 0.0 ? Icons.volume_off : Icons.volume_up,
                          size: 20,
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
                        value: controller.value.volume,
                        min: 0.0,
                        max: 1.0,
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => _onCloseButtonPressed(),
                      )
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_printDuration(Duration(milliseconds: videoPositionInMiliseconds))),
                      Text(_printDuration(controller.value.duration)),
                    ],
                  ),
                ),
                Slider(
                  inactiveColor: Colors.grey[400],
                  activeColor: Theme.of(context).accentColor,
                  value: videoPositionInMiliseconds.toDouble(),
                  onChanged: (value) {
                    _onVideoPositionChanged(value);
                  },
                  min: 0.0,
                  max: controller.value.duration != null
                      ? controller.value.duration.inMilliseconds
                          .toDouble() // added 100 milisec to maintain the max value always upper than actual value
                      : 0,
                  label: 'Video',
                ),
              ],
            ),
          ),
          Visibility(
            visible: !_isBusy && showControls,
            child: Center(
              child: IconButton(
                iconSize: 50,
                onPressed: () {
                  // Wrap the play or pause in a call to `setState`. This ensures the
                  // correct icon is shown.
                  _onPlayButtonPressed();
                },
                // Display the correct icon depending on the state of the player.
                icon: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ), // This trailing comma makes auto-formatting nicer for build methods.
              ),
            ),
          ),
        ],
      ),
    );
  }

  onTapScreen() {}

  _onVolumePressed() {}

  _onPlayButtonPressed() {}

  _onVideoPositionChanged(value) {}

  _printDuration(Duration duration) {}

  _onCloseButtonPressed() {}

  _onVolumeChanged(val) {}
}
