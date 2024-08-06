/*
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/core/di/api/response/story_data.dart';
import 'package:sample_app/values/colors.dart';
import 'package:sample_app/widget/app_image.dart';
import 'package:sample_app/widget/shimmer_widget.dart';
import 'package:video_player/video_player.dart';

class MediaDialog extends StatefulWidget {
  final Hotword data;
  final Function(int) callback;

  const MediaDialog({Key? key, required this.data, required this.callback}) : super(key: key);

  @override
  _MediaDialogState createState() => _MediaDialogState();
}

class _MediaDialogState extends State<MediaDialog> {
  static const double padding = 20;
  static const double avatarRadius = 45;

  late VideoPlayerController _controller;
  bool isImage = false;

  @override
  void initState() {
    debugPrint("mediaType: ${jsonEncode(widget.data)}");

    isImage = (widget.data.mediaName.contains(".jpg") ||
        widget.data.mediaName.contains(".jpeg") ||
        widget.data.mediaName.contains(".png"));

    if (!isImage) {
      _controller = VideoPlayerController.network(
        widget.data.mediaName,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );
      _controller.addListener(() {
        setState(() {});
        if (_controller.value.position.inSeconds == _controller.value.duration.inSeconds / 2) {
          debugPrint('video Ended');
          widget.callback(widget.data.hotId);
        }
      });
      _controller.setLooping(true);
      _controller.initialize();
    } else {
      Future.delayed(Duration(seconds: 2), () {
        widget.callback(widget.data.hotId);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: isImage
          ? AppImage(
              height: MediaQuery.of(context).size.height / 2,
              url: widget.data.mediaName,
              placeHolder: ShimmerWidget(
                itemCount: 1,
                height: MediaQuery.of(context).size.height / 2,
              ),
              boxFit: BoxFit.fill)
          : Container(
              padding: const EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_controller),
                    ClosedCaption(text: _controller.value.caption.text),
                    _ControlsOverlay(controller: _controller),
                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(playedColor: primaryColor),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller}) : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Visibility(
              visible: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  // Using less vertical padding as the text is also longer
                  // horizontally, so it feels like it would need more spacing
                  // horizontally (matching the aspect ratio of the video).
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Text('${controller.value.playbackSpeed}x'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
*/
