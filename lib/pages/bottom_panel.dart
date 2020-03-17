import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Container(
          color: Colors.green,
          height: 50,
        ));
  }
}
