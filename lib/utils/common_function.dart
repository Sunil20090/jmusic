import 'dart:convert';
import 'dart:io';
import 'package:jmusic/components/colored_button.dart';
import 'package:jmusic/constants/theme_constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';

const double DEFAULT_SPACE = 12;
const double DEFAULT_LARGE_SPACE = 20;
const double SPACE_SMALL = 4;

SizedBox addHorizontalSpace([double width = DEFAULT_SPACE]) {
  return SizedBox(width: width);
}

SizedBox addVerticalSpace([double height = DEFAULT_SPACE]) {
  return SizedBox(height: height);
}

showAlert(
  BuildContext context,
  String title,
  String message, {
  bool isError = false,
  bool isDismissible = true,
  VoidCallback? onDismiss,
}) {
  showDialog(
    context: context,
    barrierDismissible: isDismissible,
    builder: (builder) {
      var color = isError ? COLOR_BASE_ERROR : COLOR_BASE_SUCCESS;
      VoidCallback myFunc;
      if (onDismiss != null) {
        myFunc = onDismiss;
      } else {
        myFunc = () => Navigator.pop(context);
      }

      return AlertDialog(
        title: Text(title, style: TextStyle(color: color)),
        content: Text(message, style: TextStyle(color: color)),
        actions: <Widget>[
          ColoredButton(
            onPressed: myFunc,
            child: Text('OK', style: TextStyle(color: COLOR_BASE)),
          ),
        ],
      );
    },
  );
}

String formatNumber(num number) {
  if (number < 1000) {
    return number.toString();
  } else if (number < 1000000) {
    double result = number / 1000;
    return result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1) +
        'K';
  } else if (number < 1000000000) {
    double result = number / 1000000;
    return result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1) +
        'M';
  } else {
    double result = number / 1000000000;
    return result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1) +
        'B';
  }
}

String timeAgo(String isoTimestamp, {Duration? timezoneOffset}) {
  // Parse datetime from string
  DateTime dateTime = DateTime.parse(isoTimestamp);

  if (timezoneOffset != null) {
    dateTime = dateTime.toUtc().add(timezoneOffset);
  } else if (!dateTime.isUtc && dateTime.timeZoneOffset != Duration.zero) {
    dateTime = dateTime.toUtc();
  } else {
    dateTime = dateTime.toUtc();
  }

  final now = DateTime.now().toUtc();
  final diff = now.difference(dateTime);

  if (diff.isNegative) return "in the future";

  final seconds = diff.inSeconds;
  final minutes = diff.inMinutes;
  final hours = diff.inHours;
  final days = diff.inDays;

  if (seconds < 60) {
    return seconds <= 5 ? "just now" : "$seconds secs ago";
  } else if (minutes < 60) {
    return minutes == 1 ? "1 min ago" : "$minutes mins ago";
  } else if (hours < 24) {
    return hours == 1 ? "1 hour ago" : "$hours hours ago";
  } else if (days < 7) {
    return days == 1 ? "1 day ago" : "$days days ago";
  } else if (days < 30) {
    final weeks = (days / 7).floor();
    return weeks == 1 ? "1 week ago" : "$weeks weeks ago";
  } else if (days < 365) {
    final months = (days / 30).floor();
    return months == 1 ? "1 month ago" : "$months months ago";
  } else {
    final years = (days / 365).floor();
    return years == 1 ? "1 year ago" : "$years years ago";
  }
}

Future<File?> getLocalImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);

  return pickedFile != null ? File(pickedFile.path) : null;
}

Future<String> fileToBase64(File file) async {
  String base64 = await file.readAsBytes().then((bytes) => base64Encode(bytes));
  return base64;
}

String formatDurationInMinutes(Duration duration) {
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

