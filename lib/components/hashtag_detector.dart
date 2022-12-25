import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HashTagDetector {
  RichText convertHashtag(String text, List media_files, bool text_expand) {
    List<String> split = text.split(RegExp("#"));
    List<String> hashtags = split.getRange(1, split.length).fold([], (t, e) {
      var texts = e.split(" ");
      if (texts.length > 1) {
        return List.from(t)
          ..addAll(["#${texts.first}", "${e.substring(texts.first.length)}"]);
      }
      return List.from(t)..add("#${texts.first}");
    });
    return RichText(
      textAlign: TextAlign.left,
      overflow: TextOverflow.fade,
      softWrap: true,
      maxLines: text_expand == true
          ? 1000
          : media_files.isEmpty && text.toString().split('').length > 80
              ? 8
              : 2,
      text: TextSpan(
        style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400),
        children: [TextSpan(text: split.first)]..addAll(hashtags
            .map((text) => text.contains("#")
                ? TextSpan(
                    text: text,
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400))
                : TextSpan(
                    text: text,
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400)))
            .toList()),
      ),
    );
  }
}
