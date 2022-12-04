import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

class NewPost extends StatefulWidget {
  const NewPost({super.key, required this.title});

  final String title;

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  bool _visible = true;

  //text controllers
  TextEditingController post_controller = TextEditingController();

  List<File> selected_images = [];
  var user_data = Hive.box("room8").get("user_data");

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color.fromARGB(255, 0, 0, 0)),
              onPressed: () => Get.back()
              // open side menu},
              ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          // ignore: prefer_const_literals_to_create_immutables

          title: const Text(
            "Create Post",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          actions: [
            Container(
                padding: EdgeInsets.only(top: 16.sp, right: 17.sp),
                child: GestureDetector(
                    onTap: (() {
                      // if (post_controller.text.toString().isNotEmpty) {
                      loading2("Loading", context);

                      if ((post_controller.text.isNotEmpty &&
                              selected_images.isEmpty) ||
                          (post_controller.text.isEmpty &&
                              selected_images.isNotEmpty) ||
                          (post_controller.text.isNotEmpty &&
                              selected_images.isNotEmpty)) {
                        Posts()
                            .post(
                                media: selected_images,
                                text: post_controller.text.toString())
                            .then((value) => {
                                  if (value == 1)
                                    {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                      showToast("Post created successfully!"),
                                      Get.offAll(
                                          Landing(title: "Room8 Social - Home"))
                                    }
                                  else if (value == 0)
                                    {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                      showToast(
                                          "Could not upload, a server error occured!"),
                                    }
                                  else if (value == 0)
                                    {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                      showToast(
                                          "Could not upload the media, please try again!"),
                                    }
                                  else if (value == 3)
                                    {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop(),
                                      showToast(
                                          "Please pick an image less than 20MB!"),
                                    }
                                });
                      } else {
                        showToast(
                            "Please enter valid characters to make a post");
                      }

                      //}
                    }),
                    child: Text(
                      "Punch",
                      style: TextStyle(
                          color: Color(0xFFF12A6D),
                          fontWeight: FontWeight.bold,
                          fontSize: 17.sp),
                    )))
          ],
        ),
        body: AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 2000),
            child: Stack(children: [
              Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Color.fromARGB(255, 255, 255, 255),
                  child: SafeArea(
                      child: Container(
                          padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                          height: double.maxFinite,
                          width: double.maxFinite,
                          decoration: new BoxDecoration(),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height: 54,
                                      width: 54,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 173, 173, 172),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://statup.ng/room8/room8/" +
                                                      user_data[
                                                          "profile_image_url"]),
                                              fit: BoxFit.cover),
                                          shape: BoxShape.circle),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      "@" + user_data["username"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 5),
                                  ],
                                ),
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            width: 1,
                                            color: Color.fromARGB(
                                                255, 224, 224, 224))),
                                    child: TextField(
                                      controller: post_controller,
                                      maxLength: 1000,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(6),
                                          labelText: 'Want to add to the room?',
                                          alignLabelWithHint: true,
                                          floatingLabelAlignment:
                                              FloatingLabelAlignment.start),
                                      keyboardType: TextInputType.multiline,
                                      minLines: 10, // <-- SEE HERE
                                      maxLines: 20, // <-- SEE HERE
                                    )),
                                Container(
                                    height: 150,
                                    width: double.maxFinite,
                                    margin: EdgeInsets.only(top: 20),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: selected_images.length,
                                        scrollDirection: Axis.horizontal,
                                        primary: false,
                                        physics: const BouncingScrollPhysics(),
                                        separatorBuilder: (c, i) {
                                          return SizedBox(width: 10.sp);
                                        },
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            width: 140,
                                            height: 140,
                                            child: Center(
                                                child: ClipOval(
                                                    child: Container(
                                                        color: Colors.white,
                                                        child: IconButton(
                                                          icon: Icon(
                                                              Icons.close,
                                                              color: Color(
                                                                  0xFFF12A6D)),
                                                          onPressed: () {
                                                            setState(() {
                                                              selected_images
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                        )))),
                                            decoration: BoxDecoration(
                                                color: Colors.grey,
                                                image: DecorationImage(
                                                    image: FileImage(
                                                        selected_images[
                                                            index])),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8))),
                                          );
                                        }))
                              ],
                            ),
                          )))),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.maxFinite,
                    height: 60,
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Row(children: [
                      IconButton(
                        onPressed: () async {
                          ImagePicker picker = ImagePicker();
                          List<XFile> files = await picker.pickMultiImage(
                            imageQuality: 70,
                          );
                          if (files != null && files.isNotEmpty) {
                            setState(() {
                              for (var i = 0; i < files.length; i++) {
                                selected_images.add(File(files[i].path));
                              }
                            });
                          }
                        },
                        icon: SvgPicture.asset(
                          "assets/svg/Image.svg",
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Photos",
                        style:
                            TextStyle(color: Color.fromARGB(255, 56, 56, 56)),
                      )
                    ]),
                  ))
            ])));
  }
}
