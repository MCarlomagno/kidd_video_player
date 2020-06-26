<p align="center">
	<img height="300" src="https://raw.githubusercontent.com/MCarlomagno/flutter_core_architecture/master/Kidd_kode.png">
</p>

# kidd_video_player package

## Summary
 The main goal in this project is to add a video player to a flutter application in the simplest and most customizable possible way as possible.
Taking as input a source file or url, the player loads the video and plays it.

## Installation

### Dependencies:
In order to make it work, you need to add [video_player](https://pub.dev/packages/video_player) package to your dependencies:


### Step 1
In your pubspec.yml, add:

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

Import the script into the dart file that will contain the widget that uses the video player as a child:

    import  'package:kidd_video_player/kidd_video_player.dart';


### Step 4

Let's code a simple example. Put the KiddVideoPlayer() class as a child of some widget with the following parameters:

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
Be sure that the following line appears in the `<application ...>` tag located in `<project root>/android/app/src/main/AndroidMainfest.xml`:
```
<application 
    ...
    android:usesCleartextTraffic="true"
    ...
 ```   
 
And the line below outside the `<application ...>` tag:
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
		    layoutConfigs: KiddLayoutConfigs(
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
<p align="center">
	<img height="300" src="https://raw.githubusercontent.com/MCarlomagno/kidd_video_player/master/assets/screenshot1.jpg">
</p>
<p align="center">
	<img width="300" src="https://raw.githubusercontent.com/MCarlomagno/kidd_video_player/master/assets/screenshot2.jpg">
</p>

## Licence
BSD 3-Clause License

Copyright (c) 2020, Marcos Carlomagno
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived from
   this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

