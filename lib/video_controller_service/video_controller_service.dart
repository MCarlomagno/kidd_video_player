import 'dart:async';
import 'package:video_player/video_player.dart';

class VideoControllerService {

  static final VideoControllerService _videoControllerService = VideoControllerService._internal();
  VideoControllerService._internal();

  factory VideoControllerService() {
    return _videoControllerService;
  }

  // stream that listen the controller.position value
  Stream<Duration> get streamToProgress => this._controller.position.asStream();

  VideoPlayerController _controller;
  VideoPlayerController get controller => this._controller;

  VideoPlayerValue get value => _controller.value;

  void setController(VideoPlayerController controller) {
    this._controller = controller;
  }

  Future<void> initializeController() async {
    await this._controller.initialize();
    // Use the controller to loop the video.
    await _controller.setLooping(false);
  }

  Future<void> playVideo() {
    _controller.play();
  }

  Future<void> pauseVideo() {
    _controller.pause();
  }

  Future<void> seekTo(Duration value) {
    this._controller.seekTo(value);
  }

  void setLooping(bool value) {
    _controller.setLooping(value);
  }

  void setVolume(double value) {
    this._controller.setVolume(value);
  }

  void dispose() {
    this._controller.dispose();
  }
}

