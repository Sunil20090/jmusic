import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


int SEARCH_TIME_SECONDS = 1;

informDialog(BuildContext context, String title, String message) {
  showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 20),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SizedBox(
                width: 50,
                height: 50,
                
                child: Center(child: const Text('OK'))),
            )
          ],
        );
      });
}

String formatDateTime(String formatString, DateTime dateTime) {
  return DateFormat(formatString).format(dateTime);
}

OutlineInputBorder getInputBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: Colors.grey, width: 18),
      gapPadding: 12);
}

BoxDecoration getAppDecoration() {
  return BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.lightBlue, Colors.lightGreen]));
}
