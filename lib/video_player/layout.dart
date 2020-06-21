import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kidd_video_player/models/layout_configs.dart';
import 'package:kidd_video_player/video_controller_service/video_controller_service.dart';
import 'package:video_player/video_player.dart';

class Layout extends StatefulWidget {
  final Function(int) onFullScreen;

  final bool isFullScreen;

  final int videoPositionInMiliseconds;

  final LayoutConfigs layoutConfigs;

  const Layout({
    Key key,
    @required this.isFullScreen,
    this.onFullScreen,
    this.videoPositionInMiliseconds = 0,
    this.layoutConfigs = LayoutConfigs.byDefault,
  }) : super(key: key);

  @override
  _LayoutState createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  VideoControllerService _videoControllerService = VideoControllerService();

  // video progress
  int _videoPositionInMiliseconds;

  // shows play/pause button and video progress
  bool _showControls = true;

  // timer for hide controls
  Timer _timer;

  // if the user pressed mute, this variable record the last volume used
  double _lastVolume = 1.0;

  @override
  void initState() {
    super.initState();
    _videoPositionInMiliseconds = widget.videoPositionInMiliseconds;
  }

  @override
  Widget build(BuildContext context) {
    startStreaming();
    return Container(
      child: Stack(
        children: <Widget>[
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
                              widget.onFullScreen(_videoPositionInMiliseconds);
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
    onTapScreen();
    if (_videoControllerService.value.volume != 0) {
      _videoControllerService.setVolume(0.0);
    } else {
      _videoControllerService.setVolume(_lastVolume);
    }
  }

  _onPlayButtonPressed() {
    onTapScreen();
    if (_videoControllerService.value.isPlaying) {
      _videoControllerService.pauseVideo();
    } else {
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
    super.dispose();
  }
}
