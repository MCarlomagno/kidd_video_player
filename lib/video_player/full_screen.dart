import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreen extends StatefulWidget {
  final Color backgroundColor;

  final Widget child;

  const FullScreen({Key key, @required this.child, this.backgroundColor = Colors.black}) : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {

  @override
  void dispose() {
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

  _setFullDeviceOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
  }
}
