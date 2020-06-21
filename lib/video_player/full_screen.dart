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
class FullScreen extends StatefulWidget {

  /// Customizable color for the empty space around the video
  final Color backgroundColor;

  /// Widget that contains all the video UI content (included [Layout])
  final Widget child;

  const FullScreen({Key key, @required this.child, this.backgroundColor = Colors.black}) : assert(child != null), super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {

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
  _setFullDeviceOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }
}
