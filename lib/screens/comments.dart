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
import 'package:roomnew/screens/profile.dart';
import 'package:roomnew/services/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../components/post.dart';
import '../components/time_formater.dart';
import '../services/others.dart';
import '../services/posts.dart';
import 'landing.dart';
import 'new_post.dart';

class Comments extends StatefulWidget {
  const Comments(
      {super.key,
      required this.post,
      this.isFollowed,
      this.notif_id,
      this.target_comment});

  final Map post;
  final target_comment;
  final bool? isFollowed;
  final notif_id;

  @override
  State<Comments> createState() => _CommentsState();
}

ScrollController _controller = ScrollController();
late Future<dynamic> update_notification;

class _CommentsState extends State<Comments> {
  @override
  void initState() {
    _controller = ScrollController(
        initialScrollOffset: widget.target_comment != null
            ? double.parse(widget.target_comment)
            : 0);
    //  _controller.addListener();

    Future.delayed(Duration(milliseconds: 2000), () {
      if (_controller.hasClients) {
        _controller.jumpTo(300);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {});

    super.initState();

    if (widget.notif_id != null) {
      update_notification = _update_notif(widget.notif_id);
    }
  }

  bool _visible = true;
  List comments = [];

  int comment_button_status = 1;
  bool comments_loaded = false;

  TextEditingController comment_controller = TextEditingController();

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
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        color: Color.fromARGB(255, 255, 255, 255),
                        //get all posts for user
                        child: SingleChildScrollView(
                            controller: _controller,
                            child: Column(children: [
                              //logo

                              Post(
                                data: widget.post,
                                isFollowed: widget.isFollowed!,
                                onSonChanged: (id) {},
                              ),
                              SizedBox(height: 10),

                              FutureBuilder(
                                  future: Posts()
                                      .get_all_post_comments(widget.post["id"]),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (!snapshot.hasData) {
                                      return Center(child: loader());
                                    } else {
                                      if (snapshot.data.isNotEmpty &&
                                          snapshot.data != null &&
                                          snapshot.data != "failed") {
                                        comments = snapshot.data;

                                        comments_loaded = true;

                                        return ListView.separated(
                                            shrinkWrap: true,
                                            itemCount: comments!.length,
                                            controller: _controller,
                                            scrollDirection: Axis.vertical,
                                            primary: false,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            separatorBuilder: (c, i) {
                                              return SizedBox(width: 10.sp);
                                            },
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Row(
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  GestureDetector(
                                                      onTap: (() {
                                                        Get.to(Profile(
                                                            notif_id: "",
                                                            title:
                                                                "Room8 - Profile",
                                                            id: widget.post[
                                                                    "creator_details"]
                                                                ["creator_id"],
                                                            profile_img: widget
                                                                    .post["creator_details"][
                                                                "profile_image_url"],
                                                            username: widget
                                                                    .post["creator_details"]
                                                                ["username"],
                                                            isFollowed: widget
                                                                        .post[
                                                                    "creator_details"]
                                                                ["isFollow"]));
                                                      }),
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 35),
                                                          child: ClipOval(
                                                              child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            child: ImageFade(
                                                              image: NetworkImage(
                                                                  "https://statup.ng/room8/room8/" +
                                                                      comments[index]
                                                                              [
                                                                              "creator_details"]
                                                                          [
                                                                          "profile_image_url"]),
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          900),
                                                              syncDuration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          150),

                                                              alignment:
                                                                  Alignment
                                                                      .center,

                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  Container(
                                                                color: const Color(
                                                                    0xFFCFCDCA),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: const Icon(
                                                                    Icons.photo,
                                                                    color: Colors
                                                                        .white30,
                                                                    size:
                                                                        128.0),
                                                              ),
                                                              loadingBuilder: (context,
                                                                      progress,
                                                                      chunkEvent) =>
                                                                  Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                value: progress,
                                                                strokeWidth:
                                                                    0.2,
                                                                color: Colors
                                                                    .white,
                                                              )),

                                                              // displayed when an error occurs:
                                                              errorBuilder:
                                                                  (context,
                                                                          error) =>
                                                                      Container(
                                                                color: const Color(
                                                                    0xFF6F6D6A),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: const Icon(
                                                                    Icons
                                                                        .warning,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            220,
                                                                            63),
                                                                    size:
                                                                        128.0),
                                                              ),
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        173,
                                                                        173,
                                                                        172),
                                                                shape: BoxShape
                                                                    .circle),
                                                          )))),
                                                  Wrap(children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 7,
                                                                  right: 7,
                                                                  top: 10,
                                                                  bottom: 3),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          13))),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                comments[index][
                                                                        "creator_details"]
                                                                    [
                                                                    "username"],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SizedBox(
                                                                  height: 4),
                                                              Container(
                                                                  child: Text(
                                                                comments[index]
                                                                    ["content"],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ))
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    bottom: 10),
                                                            child: Text(
                                                              TimeFormatter().readTimestamp(
                                                                  int.parse(comments[
                                                                          index]
                                                                      [
                                                                      "time"])),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey),
                                                            ))
                                                      ],
                                                    )
                                                  ])
                                                ],
                                              );
                                            });
                                      } else if (snapshot.data == "failed" ||
                                          snapshot.data == null) {
                                        return SizedBox();
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                  }),

                              SizedBox(height: 100)
                            ])))))),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                color: Colors.white,
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      flex: 7,
                      child:
                          // Note: Same code is applied for the TextFormField as well
                          TextField(
                        cursorHeight: 20,
                        controller: comment_controller,
                        maxLines: 4,
                        minLines: 1,
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.only(
                              top: 2, left: 4, right: 4, bottom: 2),
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: "Drop a response",
                          hintStyle: TextStyle(
                              fontSize: 14,
                              height: 1.7,
                              color: Color.fromARGB(255, 201, 201, 201)
                              // color: white.withOpacity(.7),
                              ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(
                                    255, 182, 182, 182)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(
                                    255, 204, 204, 204)), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                        flex: 3,
                        child: GestureDetector(
                            onTap: (() {
                              if (comment_controller.text.isNotEmpty &&
                                  comment_controller.text != "") {
                                setState(() {
                                  comment_button_status = 0;
                                });
                                Posts().post_comment(
                                    media: [],
                                    text: comment_controller.text.toString(),
                                    post_id:
                                        widget.post["id"]).then((value) => {
                                      if (value == 1)
                                        {
                                          setState(() {
                                            comment_button_status = 1;
                                            FocusScope.of(context).unfocus();
                                            comment_controller.clear();
                                          }),
                                          showToast(
                                              "Your response has been added to the room!"),
                                        }
                                      else
                                        {
                                          setState(() {
                                            comment_button_status = 2;
                                          }),
                                          showToast(
                                              "Opps! A problem occured. Please try again"),
                                        }
                                    });
                              }
                            }),
                            child: comment_button_status > 0
                                ? Material(
                                    borderRadius: BorderRadius.circular(25.0),
                                    elevation: 10.sp,
                                    shadowColor:
                                        Color.fromARGB(255, 131, 131, 131),
                                    child: Container(
                                        height: 40,
                                        padding:
                                            EdgeInsets.only(top: 3, bottom: 3),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 255, 89, 23),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15.0),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                              comment_button_status == 2
                                                  ? "Retry"
                                                  : "Respond",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                        )
                                        //rest of the existing code
                                        ))
                                : Material(
                                    borderRadius: BorderRadius.circular(25.0),
                                    elevation: 10.sp,
                                    shadowColor:
                                        Color.fromARGB(255, 131, 131, 131),
                                    child: Container(
                                        height: 40,
                                        padding:
                                            EdgeInsets.only(top: 3, bottom: 3),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 255, 89, 23)
                                                  .withOpacity(0.5),
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
                                        ))))
                  ],
                ))),
      ],
    ));
  }

  Future<dynamic> _update_notif(notif_id) async {
    var o = Others().update_notif(notif_id: notif_id);

    print(o.toString());

    return o;
  }
}
