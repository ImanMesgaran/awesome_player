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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton.extended(
            label: Text('Add Music'),
            onPressed: () {
              widget.addAudioFile();
            },
            tooltip: 'Add Audio',
            icon: Icon(Icons.audiotrack),
            heroTag: 'Audio',
          ),
          FloatingActionButton.extended(
            label: Text('Add Video'),
            onPressed: () {
              widget.addVideoFile();
            },
            tooltip: 'Add Video',
            icon: Icon(Icons.music_video),
            heroTag: 'Video',
          ),
        ],
      ),
    );
  }
}
