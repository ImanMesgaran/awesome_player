import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddActionButtons extends StatefulWidget {
  final Function addAudioFile;
  final Function addVideoFile;

  AddActionButtons({this.addAudioFile, this.addVideoFile});

  @override
  State<StatefulWidget> createState() => _AddActionButtonsState();
}

class _AddActionButtonsState extends State<AddActionButtons> {
  List<File> files;

  @override
  Widget build(BuildContext context) {
    return addMediaButtons();
  }

  Widget addMediaButtons() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FloatingActionButton.extended(
            elevation: 0,
            backgroundColor: Color.fromRGBO(78, 78, 78, 1),
            label: Text(
              'Add Music',
              style:
                  TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              widget.addAudioFile();
            },
            tooltip: 'Add Audio',
            icon: Icon(
              Icons.audiotrack,
              color: Colors.white38,
            ),
            heroTag: 'Audio',
          ),
          FloatingActionButton.extended(
            backgroundColor: Color.fromRGBO(78, 78, 78, 1),
            label: Text(
              'Add Video',
              style:
                  TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              widget.addVideoFile();
            },
            tooltip: 'Add Video',
            icon: Icon(
              Icons.music_video,
              color: Colors.white38,
            ),
            heroTag: 'Video',
          ),
        ],
      ),
    );
  }
}
