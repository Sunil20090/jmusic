import 'package:flutter/material.dart';

const double UI_PADDING = 20;
const double UI_SPACE = 6;
const double UI_BORDER_RADIUS = 8;

const double UI_IMAGE_HEIGHT = 280;

const double UI_ICON_SIZE_LARGE = 42;
const double UI_ICON_SIZE_MEDIUM = 32;
const double UI_ICON_SIZE_SMALL = 22;

const Color COLOR_WHITE = Colors.white;
const Color COLOR_BLACK = Color.fromARGB(255, 34, 34, 34);
const Color COLOR_GREY = Color.fromARGB(255, 102, 102, 102);

const COLOR_PRIMARY = Color.fromARGB(255, 185, 7, 156);
const COLOR_SECONDARY = Color.fromARGB(255, 236, 158, 223);
const COLOR_BASE = Color.fromARGB(255, 229, 217, 241);
const COLOR_BASE_DARKER = Color.fromARGB(255, 226, 226, 226);

const COLOR_BASE_SUCCESS = Color.fromARGB(255, 2, 117, 60);
const COLOR_BASE_ERROR = Color.fromARGB(255, 136, 0, 0);
const COLOR_RED = Color.fromARGB(255, 245, 109, 109);

const COLOR_TRANSLUSCENT_BLACK = Color.fromARGB(118, 0, 0, 0);

const EdgeInsets CONTENT_PADDING = EdgeInsets.all(8);

const EdgeInsets SCREEN_PADDING =
    EdgeInsets.symmetric(horizontal: 8, vertical: 14);

const double CONTENT_PADDING_VALUE = 8;

getTransitionBuilder() {
  return (context, animation, secondaryAnimation, child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
    return SlideTransition(position: animation.drive(tween), child: child);
  };
}

TextTheme getTextTheme({Color color = COLOR_BLACK}) {
  return TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold, // very bold (w900 is extra bold)
      color: color,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: color,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700, // bold-ish
      color: color,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: color,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: color,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      height: 1.5,
      color: color,
    ),
  );
}
