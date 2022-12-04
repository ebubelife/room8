import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_fade/image_fade.dart';
import 'dart:math' as math;
import 'package:roomnew/components/form_fields.dart';
import 'package:roomnew/components/loading.dart';
import 'package:roomnew/components/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roomnew/screens/login.dart';
import 'package:roomnew/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../services/posts.dart';
import 'landing.dart';

class ViewPicture extends StatefulWidget {
  const ViewPicture({super.key, required this.fileUrl, required this.media_source});

  final String fileUrl, media_source;

  @override
  State<ViewPicture> createState() => _ViewPictureState();
}

class _ViewPictureState extends State<ViewPicture> {
  bool _visible = true;

  //text controllers
  TextEditingController post_controller = TextEditingController();

  List<File> selected_images = [];
  var user_data = Hive.box("room8").get("user_data");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 70, 53, 2),
        appBar: AppBar(
          foregroundColor: Color.fromARGB(255, 71, 54, 0),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () => Get.back()
              // open side menu},
              ),
          backgroundColor: Color.fromARGB(255, 71, 54, 0),
          elevation: 0.0,
          // ignore: prefer_const_literals_to_create_immutables

          title: const Text(
            "",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
                child: InteractiveViewer(
              panEnabled: false, // Set it to false
              boundaryMargin: EdgeInsets.all(100),
              minScale: 0.5,
              maxScale: 2,
              child: ImageFade(
                width: double.maxFinite,
                image: NetworkImage(
                  widget.media_source == "profile"?"https://statup.ng/room8/room8/"+widget.fileUrl:
                    "http://statup.ng/room8/room8/media/posts/images/" +
                        widget.fileUrl),
                duration: const Duration(milliseconds: 900),
                syncDuration: const Duration(milliseconds: 150),

                alignment: Alignment.center,

                fit: BoxFit.scaleDown,
                placeholder: Container(
                  color: Color.fromARGB(255, 71, 54, 0),
                  alignment: Alignment.center,
                ),
                loadingBuilder: (context, progress, chunkEvent) => Center(
                    child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 0.2,
                  color: Colors.white,
                )),

                // displayed when an error occurs:
                errorBuilder: (context, error) => Container(
                  color: const Color(0xFF6F6D6A),
                  alignment: Alignment.center,
                  child: const Icon(Icons.warning,
                      color: Colors.black26, size: 128.0),
                ),
              ),
            ))));
  }
}
