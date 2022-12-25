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
import 'package:video_player/video_player.dart';
import 'package:video_trimmer/video_trimmer.dart';
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
              icon: SvgPicture.asset(
                "assets/svg/back-arrow-svgrepo-com.svg",
                color: Color.fromARGB(255, 235, 29, 2),
                height: 21,
                width: 21,
                fit: BoxFit.scaleDown,
              ),
              onPressed: () => Get.back()
              // open side menu},
              ),
          backgroundColor: Color.fromARGB(255, 255, 237, 179).withOpacity(0.3),
          elevation: 0.0,
          // ignore: prefer_const_literals_to_create_immutables

          title: const Text(
            "Add To The Room",
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
                  color: Color.fromARGB(255, 255, 237, 179).withOpacity(0.3),
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
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            width: 1,
                                            color: Color.fromARGB(
                                                255, 224, 224, 224))),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        child: TextField(
                                          controller: post_controller,
                                          cursorColor:
                                              Color.fromARGB(255, 233, 87, 3),
                                          maxLength: 180,

                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.all(6),
                                              // counter: SizedBox.shrink(),
                                              labelText:
                                                  'Want to add to the room?',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              alignLabelWithHint: true,
                                              floatingLabelAlignment:
                                                  FloatingLabelAlignment.start),
                                          keyboardType: TextInputType.multiline,

                                          minLines: 10, // <-- SEE HERE
                                          maxLines: 20, // <-- SEE HERE
                                        ))),
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
                      ),
                      const SizedBox(width: 20),
                      IconButton(
                        onPressed: () async {
                          ImagePicker picker = ImagePicker();
                          XFile? file = await picker.pickVideo(
                              source: ImageSource.gallery);
                          if (file != null && file != null) {
                            if (file != null) {
                              Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return TrimmerView(File(file.path));
                              }));
                            }
                          }
                        },
                        icon: SvgPicture.asset(
                          "assets/svg/Video.svg",
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Videos",
                        style:
                            TextStyle(color: Color.fromARGB(255, 56, 56, 56)),
                      ),
                    ]),
                  ))
            ])));
  }
}

class TrimmerView extends StatefulWidget {
  final File file;

  TrimmerView(this.file);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;
  String? savedFile;
  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer
        .saveTrimmedVideo(
      startValue: _startValue,
      endValue: _endValue,
      onSave: (outputPath) {
        setState(() {
          print("greeee " + outputPath!);
          _progressVisibility = false;
          _value = outputPath;

          savedFile = outputPath;
          Hive.box("room8").put("saved-clip", outputPath);
        });
      },
    )
        .then((value) {
      // _value = value;
    });

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        // title: Text("Crop Video"),
      ),
      floatingActionButton: Container(
        height: 60.0,
        width: 60.0,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: _progressVisibility
                ? null
                : () async {
                    _saveVideo().then((outputPath) {
                      String retrived_clip =
                          Hive.box("room8").get("saved-clip");
                      print('OUTPUT PATHhhh: $retrived_clip');
                      final snackBar =
                          SnackBar(content: Text('Video Saved successfully'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        snackBar,
                      );

                      Get.back();
                    });
                  },
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            child: Icon(Icons.check,
                size: 35, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ),
      ),
      body: Builder(
        builder: (context) => Container(
          padding: EdgeInsets.only(bottom: 40.0),
          color: Colors.black,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Visibility(
                visible: _progressVisibility,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.red,
                ),
              ),
              Expanded(
                child: VideoViewer(trimmer: _trimmer),
              ),
              Center(
                child: TrimViewer(
                  trimmer: _trimmer,
                  viewerHeight: 50.0,
                  viewerWidth: MediaQuery.of(context).size.width,
                  maxVideoLength: const Duration(seconds: 60),
                  onChangeStart: (value) => _startValue = value,
                  onChangeEnd: (value) => _endValue = value,
                  onChangePlaybackState: (value) =>
                      setState(() => _isPlaying = value),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                child: _isPlaying
                    ? Icon(
                        Icons.pause,
                        size: 40.0,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.play_arrow,
                        size: 40.0,
                        color: Colors.white,
                      ),
                onPressed: () async {
                  bool playbackState = await _trimmer.videoPlaybackControl(
                    startValue: _startValue,
                    endValue: _endValue,
                  );
                  setState(() {
                    _isPlaying = playbackState;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
