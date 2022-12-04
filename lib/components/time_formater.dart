import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeFormatter {
  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds < 60) {
      time = "now";
    }
    if (diff.inMinutes < 60) {
      time = diff.inMinutes.toString() + "m";
    } else if (diff.inHours < 24) {
      time = diff.inHours.toString() + "h";
      ;
    } else if (diff.inHours > 24 && diff.inHours < 48) {
      time = diff.inHours.toString() + "h";
      ;
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      time = diff.inDays.toString() + 'd';
    } else if (diff.inDays == 7 || diff.inDays < 14) {
      time = '1w';
    } else if (diff.inDays > 14 && diff.inDays < 21) {
      time = '2w';
    } else if (diff.inDays > 21 && diff.inDays < 30) {
      time = '3w';
    } else if (diff.inDays > 30 && diff.inDays < 60) {
      time = '1m';
    } else if (diff.inDays > 60 && diff.inDays < 90) {
      time = '2m';
    } else if (diff.inDays > 90 && diff.inDays < 120) {
      time = '3m';
    } else if (diff.inDays > 120 && diff.inDays < 150) {
      time = '4m';
    } else if (diff.inDays > 150 && diff.inDays < 180) {
      time = '5m';
    } else if (diff.inDays > 180 && diff.inDays < 210) {
      time = '6m';
    } else if (diff.inDays > 210 && diff.inDays < 240) {
      time = '7m';
    }

    return time;
  }
}
