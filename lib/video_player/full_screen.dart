import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kidd_video_player/video_controller_service/video_controller_service.dart';
import 'package:video_player/video_player.dart';

///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
///
///
///                      FULL SCREEN!
///
///
///++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class FullScreen extends StatefulWidget {

  final Color backgroundColor;

  final Widget child;

  const FullScreen({Key key, @required this.child, this.backgroundColor = Colors.black}) : super(key: key);


  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
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
      body: Container(
        color: widget.backgroundColor,
        child: widget.child,
      ),
    );
  }
}
