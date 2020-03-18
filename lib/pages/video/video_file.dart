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
      backgroundColor: Color.fromRGBO(22, 22, 22, 1),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(0.0),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height * 0.75,
                  decoration: BoxDecoration(
                    //border: Border.all(color: Colors.grey, width: 1.0),
                    //borderRadius: BorderRadius.circular(20),
                    borderRadius: BorderRadius.only(
                      bottomRight: const Radius.circular(40.0),
                      bottomLeft: const Radius.circular(40.0),
                    ),
                    color: Color.fromRGBO(83, 83, 83, 0.8),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Center(
                    child: IconButton(
                      iconSize: 75,
                      color: Colors.grey,
                      icon: Icon(
                        widget.videoPlayerController.value.isPlaying
                            ? Icons.pause_circle_outline
                            : Icons.play_circle_outline,
                      ),
                      onPressed: () {
                        widget.videoPlayerController.value.isPlaying
                            ? widget.videoPlayerController.pause()
                            : widget.videoPlayerController.play();
                        setState(() {});
                      },
                    ),
                  ),
                )
              ],
            ),
            widget.videoPlayerController.value.initialized
                ? Container(
                    alignment: Alignment.topCenter,
                    padding: new EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * .3,
                        right: 5.0,
                        left: 5.0),
                    child: AspectRatio(
                      aspectRatio:
                          widget.videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(widget.videoPlayerController),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
