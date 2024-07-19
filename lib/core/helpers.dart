import 'package:flutter/material.dart';

Widget overrideOnTap({required Function onTap, required Widget child}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Stack(
      children: [
        child,
        Positioned.fill(
          child: Container(color: Colors.transparent),
        )
      ],
    ),
  );
}
