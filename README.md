<img height="300" src="https://github.com/MCarlomagno/flutter_core_architecture/blob/master/Kidd_kode.png">

# kidd_video_player package

## Summary
 The main goal if this project is to add a video player to a flutter application in the simplest and most customizable way as possible.
Taking as input a source file or url, the player loads the video and plays it.

## Installation

### Dependencies:
In order to make it work you need to add [video_player](https://pub.dev/packages/video_player) package to your dependencies:


### Step 1
In pubspec.yml add:

    dependencies:
	   flutter:
		sdk:
	   ...
	   video_player:
	   kidd_video_player: 
    
### Step 2
Open your terminal and run:

    flutter pub get


### Step 3

Import the script in the dart file that will contain the widget that uses the video player as a child:

    import  'package:kidd_video_player/kidd_video_player.dart';


### Step 4

Let's code a simple example, put the KiddVideoPlayer() class as a child of some widget with the following parameters:

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
Be sure to have the following line in the `<application ...>` tag located in `<project root>/android/app/src/main/Mainfest.xml`:
```
<application 
    ...
    android:usesCleartextTraffic="true"
    ...
 ```   
 
And the below line outside the `<application ...>` tag:
```
<uses-permission android:name="android.permission.INTERNET"/>
...
<application 
...
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
<img src="https://github.com/MCarlomagno/kidd_video_player/blob/master/screenshot1.jpg">
<img src="https://github.com/MCarlomagno/kidd_video_player/blob/master/screenshot2.jpg">
<img src="https://www.github.com/MCarlomagno/kidd_video_player/blob/master/screen_gif1.gif">

## Licence

TODO: Add some cool licence, do whatever you want with the code.

