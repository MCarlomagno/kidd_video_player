import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// #### Widget for show the video in full screen
/// 
/// Class navigated from original video container to display the content in full screen.
/// 
/// It recieves 2 parameters 
/// [backgroundColor] [child].
/// assertion [child] != null.
/// 
/// see also: 
/// https://github.com/MCarlomagno/kidd_video_player
class KiddFullScreen extends StatefulWidget {

  /// Customizable color for the empty space around the video
  final Color backgroundColor;

  /// Widget that contains all the video UI content (included [Layout])
  final Widget child;

  const KiddFullScreen({Key key, @required this.child, this.backgroundColor = Colors.black}) : assert(child != null), super(key: key);

  @override
  _KiddFullScreenState createState() => _KiddFullScreenState();
}

class _KiddFullScreenState extends State<KiddFullScreen> {

  @override
  void dispose() {
    // resets the device orientation before close the full screen
    _setFullDeviceOrientations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: widget.backgroundColor,
        child: widget.child,
      ),
    );
  }

  /// Sets the preferred device orientations to default
  /// Sets the system UI overlays to default
  _setFullDeviceOrientations() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }
}
