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

import '../components/post.dart';
import '../services/posts.dart';
import 'landing.dart';
import 'new_post.dart';

class Comments extends StatefulWidget {
  const Comments({super.key, required this.post, this.isFollowed});

  final Map post;
  final bool? isFollowed;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 2000),
            child: Container(
                color: Color.fromARGB(255, 32, 32, 32),
                child: SafeArea(
                    child: Container(
                        height: double.maxFinite,
                        width: double.maxFinite,
                        padding: EdgeInsets.all(10),
                        color: Color.fromARGB(255, 252, 250, 249),
                        //get all posts for user
                        child: SingleChildScrollView(
                            child: Column(children: [
                          //logo
                          Align(
                            child: Image.asset("assets/images/logo.PNG",
                                width: 90, height: 30),
                            alignment: Alignment.topLeft,
                          ),

                          Post(
                            data: widget.post,
                            isFollowed: widget.isFollowed!,
                            onSonChanged: (id) {},
                          )
                        ])))))),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child:
                          // Note: Same code is applied for the TextFormField as well
                          TextField(
                        cursorHeight: 20,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              top: 2, left: 4, right: 4, bottom: 2),
                          fillColor: Colors.white,
                          hintText: "Drop a response",
                          hintStyle: TextStyle(
                              fontSize: 14,
                              height: 1.7,
                              color: Color.fromARGB(255, 201, 201, 201)
                              // color: white.withOpacity(.7),
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(
                                    255, 221, 221, 221)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        flex: 3,
                        child: Material(
                            borderRadius: BorderRadius.circular(25.0),
                            elevation: 10.sp,
                            shadowColor: Color.fromARGB(255, 131, 131, 131),
                            child: Container(
                                height: 40,
                                padding: EdgeInsets.only(top: 3, bottom: 3),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 89, 23),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                child: Center(
                                  child: Text("Respond",
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                )
                                //rest of the existing code
                                )))
                  ],
                ))),
      ],
    ));
  }
}
