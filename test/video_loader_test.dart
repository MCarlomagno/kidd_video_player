import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kidd_video_player/video_loader.dart';

void main() {
  testWidgets('VideoLoaderWidget constructor', (WidgetTester tester) async {
    // Test code goes here.
    Widget testWidget = MediaQuery(data: MediaQueryData(), child: MaterialApp(home: VideoLoader()));
    await tester.pumpWidget(testWidget);
  });
}
