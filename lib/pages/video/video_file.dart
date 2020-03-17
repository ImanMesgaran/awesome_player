import 'dart:io';

import 'package:flutter/scheduler.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoFile extends StatefulWidget {
  final VideoPlayer videoPlayer;
  VideoPlayerController videoPlayerController;
  final File file;
  final Function audioPlayerDisposable;
  final Function videoControllerInstance;
  //final Function videoPlayerInitialization;
  final bool isPlayerInitialized;
  bool needReInstantiation;

  VideoFile(
      {@required this.videoPlayer,
      @required this.videoPlayerController,
      @required this.file,
      @required this.audioPlayerDisposable,
      @required this.videoControllerInstance,
      //@required this.videoPlayerInitialization,
      @required this.isPlayerInitialized,
      @required this.needReInstantiation});

  @override
  _VideoFileState createState() => _VideoFileState();
}

class _VideoFileState extends State<VideoFile> {
  @override
  void initState() {
    super.initState();

    String _dataSource = '';
    String _lastVideo = '';
    //bool _initialized = widget.videoPlayerController.value.initialized;

    if (widget.videoPlayerController != null) {
      _dataSource = 'file://' + widget.file.path;
      //   //_initialized = widget.videoPlayerController.value.initialized;
    }

    if (widget.isPlayerInitialized) {
      _lastVideo = widget.videoPlayerController.dataSource;
      print(
          '********************************************** $_lastVideo **********************************************');
    }

    // widget.needReInstantiation =
    //     _lastVideo.isNotEmpty && _dataSource != _lastVideo;

    if (!widget.isPlayerInitialized ||
        widget.needReInstantiation ||
        _dataSource != _lastVideo) {
      if (widget.videoPlayerController != null &&
          widget.videoPlayerController.value.isPlaying) {
        widget.videoPlayerController.pause();
      }
      widget.videoPlayerController = VideoPlayerController.file(
        widget.file,
      );
      widget.videoPlayerController
        ..initialize().then((_) {
          widget.videoPlayerController.setLooping(true);
          setState(() {});
        });
      widget.videoPlayerController
        ..addListener(() {
          setState(() {});
        });

      if (!widget.videoPlayerController.value.isPlaying) {
        widget.videoPlayerController.play();
      }

      // dispose current audio player
      widget.audioPlayerDisposable();

      widget.videoControllerInstance(widget.videoPlayerController);

      _lastVideo = widget.videoPlayerController.dataSource;

      // WidgetsBinding.instance.addPostFrameCallback((_) =>
      //     {widget.videoControllerInstance(widget.videoPlayerController)});
    }
  }

  @override
  void dispose() {
    //_videoPlayerController.removeListener(() {});
    //_videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video From Network"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              widget.videoPlayerController.value.initialized
                  ? AspectRatio(
                      aspectRatio:
                          widget.videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(widget.videoPlayerController),
                    )
                  : Container(),
              Center(
                child: IconButton(
                  icon: Icon(
                    widget.videoPlayerController.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  onPressed: () {
                    widget.videoPlayerController.value.isPlaying
                        ? widget.videoPlayerController.pause()
                        : widget.videoPlayerController.play();
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
