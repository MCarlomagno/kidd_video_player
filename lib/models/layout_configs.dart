import 'package:flutter/material.dart';

/// #### Inmutable class for UI customizations
/// 
/// It recieves 11 parameters 
/// All of them can be null and have values by default
/// 
/// see also: 
/// https://github.com/MCarlomagno/kidd_video_player

@immutable
class LayoutConfigs {

  /// Shows (or not) the slider  for volume control 
  /// and icon button for set the volume on mute.
  /// (by default [showVolumeControl = true])
  final bool showVolumeControl;

  /// Shows (or not) the slider for video progress control
  /// and the duration and progress time.
  /// (by default [showVideoControl = true])
  final bool showVideoControl;

  /// Shows (or not) the full screen button.
  /// (by default [showFullScreenButton = true])
  final bool showFullScreenButton;

  /// Sets (or not) the video looping 
  /// (by default [inLoop = true])
  final bool inLoop;

  /// Sets the play, pause, volume, full screen and video duration colors
  /// (by default [iconsColor = Colors.white])
  final Color iconsColor;

  /// Sets the slider primary color
  /// (by default [sliderColor = Colors.white])
  final Color sliderColor;

  /// Sets the slider background color
  /// (by default [backgroundSliderColor = Colors.grey])
  final Color backgroundSliderColor;

  /// Sets the color of the empty spaces between the video frame and the widget border
  /// (by default [backgroundColor = Colors.black])
  final Color backgroundColor;

  
  /// Sets the color of the [CircularProgressIndicator] when the video is loading
  /// (by default [loaderColor = Colors.white])
  final Color loaderColor;

  /// Sets the icon to pause the video
  /// (by default [pauseIcon = Icons.pause])
  final IconData pauseIcon;

  /// Sets the icon to play the video
  /// (by default [playIcon = Icons.play_arrow])
  final IconData playIcon;

  const LayoutConfigs({
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
    this.playIcon = Icons.play_arrow
  });

  /// By defaul object (used when the values are not customized).
  static const byDefault = LayoutConfigs();
 
}