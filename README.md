# kidd_video_player package

## Summary
This project is a starting point for a Dart [package](https://flutter.dev/developing-packages/). The main goal is to add a video player to a flutter application in the simplest and most customizable way possible.
Taking as input a source file or url the player loads the video and plays it.

## Installation

### Dependencies:
To make it work you need to add [video_player](https://pub.dev/packages/video_player) package to your dependencies:


### Step 1
In pubspec.yml add:

    dependencies:
	   flutter:
		sdk:
	   ...
	   video_player:
	   kidd_video_player: 
    
### Step 2
Then open your terminal and run:

    flutter pub get


### Step 3

Import the widget in the dart file that contains the widget that will contain the video player:

    import  'package:kidd_video_player/kidd_video_player.dart';


### Step 4

Let's code a simple example, put the KiddVideoPlayer() class as a child of some widget:

    ...
    child: Container(
	    width: MediaQuery.of(context).size.width,
	    height: 500,
	    child: KiddVideoPlayer(
		    fromUrl: true,
		    videoUrl: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
		),
	),
	...



## Considerations
### For Android:
Ensure to have in the *Mainfest.xml* application tag located in `<project root>/android/app/src/main/Mainfest.xml`:
```
<application 
    ...
    android:usesCleartextTraffic="true"
    ...
 ```   
 
And the avobe line in your Mainfest.xml
```
<uses-permission android:name="android.permission.INTERNET"/>
```   
This entry allows your app to access video files by URL.

### For iOS

Warning: The video player is not functional on iOS simulators. An iOS device must be used during development/testing.

Add the following entry to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>

```

This entry allows your app to access video files by URL.

## Usage

### Complete example

    ...
    child: Container(
	    width: MediaQuery.of(context).size.width,
	    height: 500,
	    child: KiddVideoPlayer(
		    videoFile: _videoFile,
		    fromUrl: false,
		    layoutConfigs: LayoutConfigs(
			    backgroundColor: Colors.black,
			    backgroundSliderColor: Colors.grey,
			    iconsColor: Colors.white,
			    inLoop: false,
			    loaderColor: Colors.blue,
			    pauseIcon: Icons.pause_circle_filled,
			    playIcon: Icons.play_circle_filled,
			    showFullScreenButton: true,
			    showVideoControl: true,
			    showVolumeControl: true,
			    sliderColor: Colors.blue,
			    ),
		  ),
	...

### Parameters

 -  **videoFile** (File)
 -  **videoUrl** (String)
 -  **fromUrl** (bool)
 - **layoutConfigs** (LayoutConfigs)
	 -  **backgroundColor**(Color)
	 -  **backgroundSliderColor**(Color)
	 -  **iconsColor**(Color)
	 -  **inLoop**(bool)
	 -  **loaderColor**(Color)
	 -  **pauseIcon**(IconData)
	 -  **playIcon**:(IconData)
	 -  **showFullScreenButton**(bool)
	 -  **showVideoControl**(bool)
	 -  **showVolumeControl**(bool)
	 -  **sliderColor**(Color)

## Screenshots

TODO: Upload some cool screenshots.

## Licence

TODO: Add some cool licence, do whatever you want with the code.

