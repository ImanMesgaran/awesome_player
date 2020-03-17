import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import '../models/media_file.dart';
import '../pages/audio/audio_local.dart';
import '../pages/video/video_file.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaListView extends StatefulWidget {
  final List<MediaFile> files;
  final AudioPlayer audioPlayer;
  final String audioPlayerId;
  final VideoPlayer videoPlayer;

  MediaListView(
      {@required this.audioPlayer,
      @required this.audioPlayerId,
      @required this.videoPlayer,
      @required this.files});

  @override
  State<StatefulWidget> createState() => _MediaListViewState();
}

class _MediaListViewState extends State<MediaListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.files != null && widget.files.isNotEmpty
          ? widget.files.length
          : 1,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            widget.files[index].fileName,
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        widget.files[index].fileType == MediaType.audio
                            ?
                            //startPlaying(widget.files[index].file);
                            AudioLocal(
                                audioPlayer: widget.audioPlayer,
                                audioPlayerId: widget.audioPlayerId,
                                file: widget.files[index].file,
                              )
                            : VideoFile(
                                videoPlayer: widget.videoPlayer,
                                file: widget.files[index].file,
                              )));
          },
        );
      },
    );
  }
/*
  bool isPlaying = false;
  bool isStarted = false;

  Duration duration;
  int time;

  String timeLeft = "";
  double progress = 0.0;

  startPlaying(File file) async {
    if (!isStarted) {
      await widget.audioPlayer.play(file.path, isLocal: true);
      isStarted = true;
    } else
      await widget.audioPlayer.resume();
    // time  = await audioPlayer.getDuration();
  }

  getTimeLeft() {
    if (duration == null) {
      setState(() {
        timeLeft = "Time Left 0s";
      });
    } else {
      setState(() {
        timeLeft = "Time Left ${duration.inSeconds}s";
      });
    }
  }

  getProgress() {
    if (time == null || duration == null) {
      setState(() {
        progress = 0.0;
      });
    } else {
      setState(() {
        progress = time / (duration.inMilliseconds);
      });
    }
  }
  */
}
