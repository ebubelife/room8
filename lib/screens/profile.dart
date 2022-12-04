import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:image_fade/image_fade.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:roomnew/components/user_posts.dart';
import 'package:roomnew/screens/landing.dart';
import 'package:roomnew/screens/signup.dart';
import 'package:roomnew/screens/view_picture.dart';
import '../components/loading.dart';
import '../components/post.dart';
import '../components/toast.dart';
import '../services/posts.dart';
import '../services/users.dart';
import 'package:image_cropper/image_cropper.dart';

class Profile extends StatefulWidget {
  const Profile(
      {super.key,
      required this.title,
      required this.id,
      required this.profile_img,
      required this.isFollowed,
      required this.username});

  final String title, id, profile_img, username;
  final bool isFollowed;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var user_data = Hive.box("room8").get("user_data");

  bool _visible = true;
  var postsFromRefresh = [];
  int _selectedIndex = 0;
  List? posts = [];

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool display_error_img = true;
  late Future<dynamic> future;

  @override
  void initState() {
    future = _fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String? username = user_data["username"];
    String? profile_img_url = user_data["profile_image_url"];

    String? follwowingCount = "";
    String? follwowersCount = "";

    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
            future: future,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: loader());
              } else {
                if (snapshot.data.isNotEmpty &&
                    snapshot.data != null &&
                    snapshot.data != "failed") {
                  List? posts = snapshot.data;

                  var user_data_for_profile_inview =
                      Hive.box("room8").get("user_data_for_profile_inview");
                  user_data_for_profile_inview != null
                      ? follwowingCount =
                          user_data_for_profile_inview["following_count"]
                      : follwowingCount;

                  user_data_for_profile_inview != null
                      ? follwowersCount =
                          user_data_for_profile_inview["follower_count"]
                      : follwowersCount;

                  user_data_for_profile_inview == null
                      ? print("no data")
                      : print("data");

                  return Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      color: Color.fromARGB(255, 252, 250, 249),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        Container(
                            width: double.maxFinite,
                            height: 100,
                            margin: EdgeInsets.only(top: 60),
                            child: Row(
                              children: [
                                Spacer(),
                                SizedBox(
                                  width: 20,
                                ),
                                Center(
                                    child: Stack(
                                  children: [
                                    GestureDetector(
                                        onTap: (() {
                                          Get.to(ViewPicture(
                                              media_source: "profile",
                                              fileUrl: widget.id ==
                                                      user_data["id"]
                                                  ? profile_img_url.toString()
                                                  : widget.profile_img));
                                        }),
                                        child: Center(
                                            child: ClipOval(
                                                child: Container(
                                          height: 90,
                                          width: 90,
                                          child: ImageFade(
                                            image: NetworkImage(widget.id ==
                                                    user_data["id"]
                                                ? "https://statup.ng/room8/room8/" +
                                                    profile_img_url.toString()
                                                : "https://statup.ng/room8/room8/" +
                                                    widget.profile_img),
                                            duration: const Duration(
                                                milliseconds: 900),
                                            syncDuration: const Duration(
                                                milliseconds: 150),

                                            alignment: Alignment.center,

                                            fit: BoxFit.cover,
                                            placeholder: Container(
                                              color: const Color(0xFFCFCDCA),
                                              alignment: Alignment.center,
                                              child: const Icon(Icons.photo,
                                                  color: Colors.white30,
                                                  size: 128.0),
                                            ),
                                            loadingBuilder: (context, progress,
                                                    chunkEvent) =>
                                                Center(
                                                    child:
                                                        CircularProgressIndicator(
                                              value: progress,
                                              strokeWidth: 0.2,
                                              color: Colors.white,
                                            )),

                                            // displayed when an error occurs:
                                            errorBuilder: (context, error) =>
                                                Container(
                                              color: const Color(0xFF6F6D6A),
                                              alignment: Alignment.center,
                                              child: const Icon(Icons.warning,
                                                  color: Color.fromARGB(
                                                      255, 255, 220, 63),
                                                  size: 128.0),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 173, 173, 172),
                                              shape: BoxShape.circle),
                                        )))),
                                    widget.id == user_data["id"]
                                        ? Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () async {
                                                ImagePicker picker =
                                                    ImagePicker();
                                                XFile? file =
                                                    await picker.pickImage(
                                                        source: ImageSource
                                                            .gallery);
                                                if (file != null) {
                                                  CroppedFile? cropped =
                                                      await ImageCropper()
                                                          .cropImage(
                                                    sourcePath: file.path,
                                                    cropStyle: CropStyle.circle,
                                                    uiSettings: [
                                                      AndroidUiSettings(
                                                          toolbarTitle:
                                                              'Edit Image',
                                                          toolbarColor:
                                                              Colors.deepOrange,
                                                          toolbarWidgetColor:
                                                              Colors.white,
                                                          initAspectRatio:
                                                              CropAspectRatioPreset
                                                                  .original,
                                                          lockAspectRatio:
                                                              false),
                                                      IOSUiSettings(
                                                        title: 'Edit Image',
                                                      ),
                                                      WebUiSettings(
                                                        context: context,
                                                      ),
                                                    ],
                                                  );
                                                  if (cropped != null) {
                                                    loading2("", context);
                                                    Users()
                                                        .updateProfilePic(
                                                            profile_pic: File(
                                                                cropped.path))
                                                        .then((value) {
                                                      if (value == 1) {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        setState(() {
                                                          future = _fetchData();
                                                        });
                                                        showToast(
                                                            "Your profile picture has been changed!");
                                                      } else {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();

                                                        showToast(
                                                            value.toString());
                                                      }
                                                    });
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      Color.fromARGB(
                                                          255, 43, 43, 43),
                                                      Color.fromARGB(
                                                          255, 105, 105, 105)
                                                    ],
                                                  ),
                                                ),
                                                child: const Icon(
                                                  Icons.camera_enhance,
                                                  color: Colors.white,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                  ],
                                )),
                                Spacer(),
                                user_data["id"] == widget.id
                                    ? PopupMenuButton(
                                        itemBuilder: (ctx) {
                                          return [
                                            PopupMenuItem(
                                              value: 'deactivate',
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 33,
                                                    height: 33,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Color.fromARGB(
                                                          255, 255, 225, 91),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.share,
                                                        size: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  const Text(
                                                    "Deactivate Account",
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 46, 46, 46),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ];
                                        },
                                        offset: const Offset(0, 40),
                                        onSelected: (value) {
                                          Get.dialog(Dialog(
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.6),
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "This action will permanently delete all of your data and log you out. Are you sure you want to continue?",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop(),
                                                          child: Text(
                                                            "No",
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      89,
                                                                      180,
                                                                      255),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          style: ButtonStyle(
                                                            side:
                                                                MaterialStateProperty
                                                                    .all(
                                                              BorderSide(
                                                                  color: Colors
                                                                      .blue,
                                                                  width: 2),
                                                            ),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .white),
                                                            shape:
                                                                MaterialStateProperty
                                                                    .all(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 20),
                                                      Expanded(
                                                        child: TextButton(
                                                          onPressed: () {
                                                            loading2("Loading",
                                                                context);
                                                            Users()
                                                                .deactivate(
                                                                    id_to_deactivate:
                                                                        user_data[
                                                                            "id"])
                                                                .then(
                                                                    (value) => {
                                                                          if (value ==
                                                                              1)
                                                                            {
                                                                              Hive.box("room8").put("loggedIn", false),
                                                                              Hive.box("room8").delete("user_data"),
                                                                              Hive.box("room8").delete("access_token"),
                                                                              Hive.box("room8").delete("user_data_for_profile_inview"),

                                                                              Get.to(Signup(title: "Room8 - Signup")),

                                                                              // Navigator.of(context, rootNavigator: true).pop(),
                                                                              // Navigator.of(context, rootNavigator: true).pop(),
                                                                              Navigator.of(context, rootNavigator: true).pop(),

                                                                              Navigator.of(context, rootNavigator: true).pop(),
                                                                              Get.offAll(Signup(title: "Room8 - Signup"))
                                                                            }
                                                                          else
                                                                            {
                                                                              showToast("Oops! An error occured! Please try"),
                                                                              Navigator.of(context, rootNavigator: true).pop(),
                                                                              Navigator.of(context, rootNavigator: true).pop(),
                                                                            }
                                                                        });
                                                          },
                                                          child: Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Color
                                                                        .fromARGB(
                                                                            255,
                                                                            106,
                                                                            187,
                                                                            253)),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ));
                                        })
                                    : SizedBox()
                              ],
                            )),
                        SizedBox(height: 12),
                        Container(
                          width: double.maxFinite,
                          child: Center(
                              child: Text(
                            widget.id == user_data["id"]
                                ? "@" + user_data["username"]
                                : "@" + widget.username,
                            maxLines: 1,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                        ),
                        SizedBox(height: 15),
                        Container(
                            padding: EdgeInsets.only(left: 40, right: 40),
                            child: Center(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.id == user_data["id"]
                                          ? user_data["follower_count"]
                                          : follwowingCount,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "Followers",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.id == user_data["id"]
                                          ? user_data["following_count"]
                                          : follwowersCount,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text(
                                      "Following",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                widget.id != user_data["id"]
                                    ? GestureDetector(
                                        onTap: () => ({
                                              Users()
                                                  .followUser(
                                                      id_to_follow:
                                                          user_data_for_profile_inview[
                                                              "id"])
                                                  .then((value) => {
                                                        if (value == 1)
                                                          {
                                                            setState(() {
                                                              int new_follow_count =
                                                                  (int.parse(
                                                                          follwowingCount!) +
                                                                      1);
                                                              user_data_for_profile_inview[
                                                                      "isFollowed"] =
                                                                  true;

                                                              print(
                                                                  follwowingCount);
                                                              future =
                                                                  _fetchData();
                                                            }),
                                                            showToast(
                                                                "You just followed a user!"),
                                                          }
                                                        else if (value == 2)
                                                          {
                                                            setState(() {
                                                              user_data_for_profile_inview[
                                                                      "isFollowed"] =
                                                                  false;

                                                              future =
                                                                  _fetchData();
                                                            }),
                                                            showToast(
                                                                "You just unfollowed a user!"),
                                                          }
                                                        else if (value == 0)
                                                          {
                                                            showToast(
                                                                "Operation failed"),
                                                          }
                                                      })
                                              //}
                                            }),
                                        child: SvgPicture.asset(
                                          "assets/svg/follow.svg",
                                          height: 21,
                                          width: 21,
                                          fit: BoxFit.scaleDown,
                                          color: user_data_for_profile_inview[
                                                      "isFollowed"] ==
                                                  true
                                              ? Color.fromARGB(255, 221, 30, 0)
                                              : Color.fromARGB(255, 0, 0, 0),
                                        ))
                                    : SizedBox(),
                              ],
                            ))),
                        SizedBox(height: 7),
                        Container(
                            child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: posts!.length,
                                scrollDirection: Axis.vertical,
                                primary: false,
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder: (c, i) {
                                  return SizedBox(
                                    height: 10.sp,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return getPosts(
                                    posts[index],
                                  );
                                }))
                      ])));
                } else if (snapshot.data.isEmpty &&
                    Hive.box("room8").get("user_data_for_profile_inview") !=
                        null) {
                  var user_data_for_profile_inview =
                      Hive.box("room8").get("user_data_for_profile_inview");
                  follwowersCount =
                      user_data_for_profile_inview["follower_count"];
                  follwowingCount =
                      user_data_for_profile_inview["following_count"];
                  return Scaffold(
                      body: Container(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          color: Color.fromARGB(255, 252, 250, 249),
                          child: SingleChildScrollView(
                              child: Column(children: [
                            Container(
                                width: double.maxFinite,
                                height: 100,
                                margin: EdgeInsets.only(top: 60),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    SizedBox(
                                      width: 50,
                                    ),
                                    Center(
                                        child: Stack(
                                      children: [
                                        GestureDetector(
                                            onTap: (() {
                                              Get.to(ViewPicture(
                                                  media_source: "profile",
                                                  fileUrl: widget.id ==
                                                          user_data["id"]
                                                      ? profile_img_url
                                                          .toString()
                                                      : widget.profile_img));
                                            }),
                                            child: ClipOval(
                                                child: Container(
                                              height: 90,
                                              width: 90,
                                              child: ImageFade(
                                                image: NetworkImage(widget.id ==
                                                        user_data["id"]
                                                    ? "https://statup.ng/room8/room8/" +
                                                        profile_img_url
                                                            .toString()
                                                    : "https://statup.ng/room8/room8/" +
                                                        widget.profile_img),
                                                duration: const Duration(
                                                    milliseconds: 900),
                                                syncDuration: const Duration(
                                                    milliseconds: 150),

                                                alignment: Alignment.center,

                                                fit: BoxFit.cover,
                                                placeholder: Container(
                                                  color:
                                                      const Color(0xFFCFCDCA),
                                                  alignment: Alignment.center,
                                                  child: const Icon(Icons.photo,
                                                      color: Colors.white30,
                                                      size: 128.0),
                                                ),
                                                loadingBuilder: (context,
                                                        progress, chunkEvent) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                  value: progress,
                                                  strokeWidth: 0.2,
                                                  color: Colors.white,
                                                )),

                                                // displayed when an error occurs:
                                                errorBuilder:
                                                    (context, error) =>
                                                        Container(
                                                  color:
                                                      const Color(0xFF6F6D6A),
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                      Icons.warning,
                                                      color: Color.fromARGB(
                                                          255, 255, 220, 63),
                                                      size: 128.0),
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Color.fromARGB(
                                                      255, 173, 173, 172),
                                                  shape: BoxShape.circle),
                                            ))),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () async {
                                              ImagePicker picker =
                                                  ImagePicker();
                                              XFile? file =
                                                  await picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (file != null) {
                                                CroppedFile? cropped =
                                                    await ImageCropper()
                                                        .cropImage(
                                                  sourcePath: file.path,
                                                  cropStyle: CropStyle.circle,
                                                  uiSettings: [
                                                    AndroidUiSettings(
                                                        toolbarTitle:
                                                            'Edit Image',
                                                        toolbarColor:
                                                            Colors.deepOrange,
                                                        toolbarWidgetColor:
                                                            Colors.white,
                                                        initAspectRatio:
                                                            CropAspectRatioPreset
                                                                .original,
                                                        lockAspectRatio: false),
                                                    IOSUiSettings(
                                                      title: 'Edit Image',
                                                    ),
                                                    WebUiSettings(
                                                      context: context,
                                                    ),
                                                  ],
                                                );
                                                if (cropped != null) {
                                                  loading2("", context);
                                                  Users()
                                                      .updateProfilePic(
                                                          profile_pic: File(
                                                              cropped.path))
                                                      .then((value) {
                                                    if (value == 1) {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      setState(() {
                                                        future = _fetchData();
                                                      });
                                                      showToast(
                                                          "Your profile picture has been changed!");
                                                    } else {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();

                                                      showToast(
                                                          value.toString());
                                                    }
                                                  });
                                                }
                                              }
                                            },
                                            child: Container(
                                              width: 25,
                                              height: 25,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 43, 43, 43),
                                                    Color.fromARGB(
                                                        255, 105, 105, 105)
                                                  ],
                                                ),
                                              ),
                                              child: const Icon(
                                                Icons.camera_enhance,
                                                color: Colors.white,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                    Spacer(),
                                    Container(
                                      height: double.maxFinite,
                                      margin: EdgeInsets.only(bottom: 60),
                                      child: PopupMenuButton(
                                          onSelected: (value) {
                                            Get.dialog(Dialog(
                                              backgroundColor:
                                                  Colors.grey.withOpacity(0.6),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "This action will permanently delete all of your data and log you out. Are you sure you want to continue?",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context,
                                                                        rootNavigator:
                                                                            true)
                                                                    .pop(),
                                                            child: Text(
                                                              "No",
                                                              style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        89,
                                                                        180,
                                                                        255),
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            style: ButtonStyle(
                                                              side:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                BorderSide(
                                                                    color: Colors
                                                                        .blue,
                                                                    width: 2),
                                                              ),
                                                              backgroundColor:
                                                                  MaterialStateProperty
                                                                      .all(Colors
                                                                          .white),
                                                              shape:
                                                                  MaterialStateProperty
                                                                      .all(
                                                                RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Expanded(
                                                          child: TextButton(
                                                            onPressed: () {
                                                              loading2(
                                                                  "Loading",
                                                                  context);
                                                              Users()
                                                                  .deactivate(
                                                                      id_to_deactivate:
                                                                          user_data[
                                                                              "id"])
                                                                  .then(
                                                                      (value) =>
                                                                          {
                                                                            loader(),
                                                                            if (value ==
                                                                                1)
                                                                              {
                                                                                Hive.box("room8").put("loggedIn", false),
                                                                                Hive.box("room8").delete("user_data"),
                                                                                Hive.box("room8").delete("access_token"),
                                                                                Hive.box("room8").delete("user_data_for_profile_inview"),
                                                                                Navigator.of(context, rootNavigator: true).pop(),
                                                                                Navigator.of(context, rootNavigator: true).pop(),
                                                                                Get.offAll(Signup(title: "Room8 - Signup"))
                                                                              }
                                                                            else
                                                                              {
                                                                                showToast("Oops! An error occured! Please try")
                                                                              }
                                                                          });
                                                            },
                                                            child: Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            style: ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStateProperty.all(
                                                                      Color.fromARGB(
                                                                          255,
                                                                          106,
                                                                          187,
                                                                          253)),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ));
                                          },
                                          icon: SvgPicture.asset(
                                            "assets/svg/menu-svgrepo-com.svg",
                                            height: 16,
                                            width: 16,
                                            fit: BoxFit.scaleDown,
                                            color:
                                                Color.fromARGB(255, 32, 32, 32),
                                          ),
                                          itemBuilder: (ctx) {
                                            return [
                                              PopupMenuItem(
                                                value: 'deactivate',
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 33,
                                                      height: 33,
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      240,
                                                                      131,
                                                                      30)),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.no_accounts,
                                                          size: 15,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      "Deactivate Account",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 46, 46, 46),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ];
                                          }),
                                    )
                                  ],
                                )),
                            Container(
                              width: double.maxFinite,
                              child: Center(
                                  child: Text(
                                widget.id == user_data["id"]
                                    ? "@" + user_data["username"]
                                    : "@" + widget.username,
                                maxLines: 1,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                            ),
                            SizedBox(height: 15),
                            Container(
                                padding: EdgeInsets.only(left: 40, right: 40),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.id == user_data["id"]
                                              ? user_data["follower_count"]
                                              : follwowingCount,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "Following",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          widget.id == user_data["id"]
                                              ? user_data["following_count"]
                                              : follwowersCount,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "Followers",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    widget.id != user_data["id"]
                                        ? GestureDetector(
                                            onTap: () => ({
                                                  Users()
                                                      .followUser(
                                                          id_to_follow:
                                                              user_data_for_profile_inview[
                                                                  "id"])
                                                      .then((value) => {
                                                            if (value == 1)
                                                              {
                                                                setState(() {
                                                                  user_data_for_profile_inview[
                                                                          "isFollowed"] =
                                                                      true;
                                                                }),
                                                                showToast(
                                                                    "You just followed a user!"),
                                                              }
                                                            else if (value == 2)
                                                              {
                                                                setState(() {
                                                                  user_data_for_profile_inview[
                                                                          "isFollowed"] =
                                                                      true;
                                                                }),
                                                                showToast(
                                                                    "You just unfollowed a user!"),
                                                              }
                                                            else if (value == 0)
                                                              {
                                                                showToast(
                                                                    "Operation failed"),
                                                              }
                                                          })
                                                  //}
                                                }),
                                            child: SvgPicture.asset(
                                              "assets/svg/follow.svg",
                                              height: 21,
                                              width: 21,
                                              fit: BoxFit.scaleDown,
                                              color:
                                                  user_data_for_profile_inview[
                                                              "isFollowed"] ==
                                                          true
                                                      ? Color.fromARGB(
                                                          255, 221, 30, 0)
                                                      : Color.fromARGB(
                                                          255, 87, 86, 86),
                                            ))
                                        : SizedBox(),
                                  ],
                                ))),
                            SizedBox(
                              height: 100,
                            ),
                            Center(
                                child: Text("No posts yet",
                                    style: TextStyle(color: Colors.grey)))
                          ]))));
                } else {
                  display_error_img == true;

                  return Container(
                      margin: EdgeInsets.only(top: 80),
                      child: Center(
                          child: GestureDetector(
                              onTap: (() {
                                setState(() {
                                  future = _fetchData();
                                });
                              }),
                              child: display_error_img == true
                                  ? Image.asset(
                                      "assets/images/man-confusing-due-to-no-connection-error-4558763-3780059.png",
                                      height: 360,
                                      width: 360,
                                    )
                                  : SizedBox())));
                }
              }
            }));
  }

  Widget getPosts(
    Map posts,
  ) {
    return UserPost(
      data: posts,
      onSonChanged: (id) {
        remove_item_from_list();
      },
    );
  }

  //create method to remove item from list when data is changed in child
  void remove_item_from_list() {
    setState(() {
      print("eliminated");
    });
  }

  void call_delete_user_dialog() {
    AlertDialog(
      title: Text("Success"),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
      actionsOverflowButtonSpacing: 20,
      actions: [
        ElevatedButton(onPressed: () {}, child: Text("Back")),
        ElevatedButton(onPressed: () {}, child: Text("Next")),
      ],
      content: Text("Saved successfully"),
    );
  }

  Future<dynamic> _fetchData() async {
    String id_to_get_post =
        user_data["id"] == widget.id ? user_data["id"] : widget.id;
    var o = Posts().get_all_users_posts(id_to_get_post);

    print(o.toString());

    return o;
  }
}
