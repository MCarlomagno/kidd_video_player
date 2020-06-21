


import 'package:flutter/material.dart';

@immutable
class LayoutConfigs {

  final bool showVolumeControl;
  final bool showVideoControl;
  final bool showFullScreenButton;
  final bool inLoop;
  final Color iconsColor;
  final Color sliderColor;
  final Color backgroundSliderColor;
  final Color backgroundColor;
  final Color loaderColor;
  final IconData pauseIcon;
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

  static const byDefault = LayoutConfigs();
 
}