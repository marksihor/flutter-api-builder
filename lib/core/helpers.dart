import 'package:flutter/material.dart';

Widget disableGestureDetection(Widget widget) {
  return Stack(
    children: [
      widget,
      Positioned.fill(
        child: Container(color: Colors.transparent),
      )
    ],
  );
}
