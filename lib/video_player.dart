import 'dart:io';
import 'package:flutter/material.dart';

class KiddVideoPlayer extends StatefulWidget {
  const KiddVideoPlayer({Key key, @required this.file}) : super(key: key);
  final File file;

  @override
  _KiddVideoPlayerState createState() => _KiddVideoPlayerState();
}

class _KiddVideoPlayerState extends State<KiddVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(color: const Color(0xFFFFE306));
  }
}