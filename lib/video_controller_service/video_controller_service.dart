import 'dart:async';
import 'package:video_player/video_player.dart';

/// #### Singleton service for video player controller handling
///
/// The propose of this service is to add a new level of abstraction to manage the
/// video controller and make it more ease to access from different widgets.
///
/// see also:
/// https://github.com/MCarlomagno/kidd_video_player

class KiddVideoControllerService {
  /// Singleton initialization.
  static final KiddVideoControllerService _videoControllerService =
      KiddVideoControllerService._internal();
  KiddVideoControllerService._internal();

  /// Factory pattern for constrictor.
  factory KiddVideoControllerService() {
    return _videoControllerService;
  }

  /// controller that will handle video player actions.
  VideoPlayerController _controller;
  VideoPlayerController get controller => this._controller;

  /// stream that listen the [controller.position] value
  Stream<Duration> get streamToProgress => this._controller.position.asStream();

  /// stream that listen the [controller] buffered value.
  List<DurationRange> get buffered => this._controller.value.buffered;

  /// stream that listen the [controller] value.
  VideoPlayerValue get value => _controller.value;

  /// Setter for [_controller].
  void setController(VideoPlayerController controller) {
    this._controller = controller;
  }

  /// Initializes the controller and sets the looping with the given boolean value.
  Future<void> initializeController({bool inLoop}) async {
    await this._controller.initialize();
    // Use the controller to loop the video.
    await _controller.setLooping(inLoop);
  }

  /// Plays the video.
  Future<void> playVideo() async {
    await _controller.play();
  }

  /// Pauses the video.
  Future<void> pauseVideo() async {
    await _controller.pause();
  }

  /// Moves the video progress to the given Duration value
  Future<void> seekTo(Duration value) async {
    await this._controller.seekTo(value);
  }

  /// Sets the loop boolean variable for restart the video when it finishes.
  Future<void> setLooping(bool value) async {
    await _controller.setLooping(value);
  }

  /// Sets the volume value (between 0.0 and 1.0).
  void setVolume(double value) {
    this._controller.setVolume(value);
  }

  void dispose() {
    // disposes the controller.
    this._controller.dispose();
  }
}
