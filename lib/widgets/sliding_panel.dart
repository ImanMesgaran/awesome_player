import 'dart:io';

import 'package:awesome_player/models/media_file.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../pages/bottom_panel.dart';
import '../pages/now_playing.dart';
import 'media_list_view.dart';

class SlidingPanel extends StatelessWidget {
  const SlidingPanel({
    Key key,
    @required PanelController panelController,
    @required this.files,
  })  : _panelController = panelController,
        super(key: key);

  final PanelController _panelController;
  final List<MediaFile> files;

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      panel: NowPlayingScreen(),
      controller: _panelController,
      minHeight: 90,
      isDraggable: false,
      maxHeight: MediaQuery.of(context).size.height,
      backdropEnabled: true,
      backdropOpacity: 0.5,
      parallaxEnabled: true,
      collapsed: Material(
        child: BottomPanel(),
      ),
      body: MaterialApp(
        home: MediaListView(files: files),
      ),
    );
  }
}
