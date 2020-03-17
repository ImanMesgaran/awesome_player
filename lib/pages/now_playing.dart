import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NowPlayingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NowPlayingScreenState();
}

class NowPlayingScreenState extends State<NowPlayingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Row(
        children: <Widget>[
          Container(
            height: 10,
            color: Colors.red,
          )
        ],
      ),
    );
  }
}
