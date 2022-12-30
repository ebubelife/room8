import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:roomnew/components/hashtag_detector.dart';
import 'package:roomnew/components/time_formater.dart';
import 'package:roomnew/screens/comments.dart';
import 'package:roomnew/screens/view_picture.dart';
import 'package:roomnew/services/posts.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_fade/image_fade.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';
import '../services/users.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../components/toast.dart';
import 'package:hive/hive.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:roomnew/components/loading.dart';
import 'package:flutter_svg/flutter_svg.dart';

//declare type dev of callback
typedef void VoidCallback(int id);

class UserPost extends StatefulWidget {
  const UserPost({super.key, required this.data, required this.onSonChanged});

  final Map data;
  final VoidCallback onSonChanged;

  @override
  State<UserPost> createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  var user_data = Hive.box("room8").get("user_data");
  double dots_indicator_position = 0.0;
  bool? text_expand = false;
  int? max_lines_for_post;
  bool? isFollow;
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.

    if (widget.data["post_type"] == "VIDEO") {
      _controller = VideoPlayerController.network(
        'https://statup.ng/room8/room8/media/posts/videos/' +
            widget.data["media"][0],
      );

      _initializeVideoPlayerFuture = _controller!.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? username = user_data["username"];
    String? profile_img_url = user_data["profile_image_url"];
    List<dynamic> media_files = widget.data["media"];
    return Container(
        margin: EdgeInsets.only(top: 0, left: 3, right: 3),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Row(children: [
                SizedBox(
                  width: 10,
                ),
                ClipOval(
                    child: Container(
                  height: 47,
                  width: 47,
                  child: ImageFade(
                    image: NetworkImage("https://statup.ng/room8/room8/" +
                        widget.data["creator_details"]["profile_image_url"]!),
                    duration: const Duration(milliseconds: 900),
                    syncDuration: const Duration(milliseconds: 150),

                    alignment: Alignment.center,

                    fit: BoxFit.cover,
                    placeholder: Container(
                      color: const Color(0xFFCFCDCA),
                      alignment: Alignment.center,
                      child: const Icon(Icons.photo,
                          color: Colors.white30, size: 128.0),
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
                          color: Color.fromARGB(255, 255, 220, 63),
                          size: 128.0),
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 173, 173, 172),
                      shape: BoxShape.circle),
                )),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: Container(
                  margin: EdgeInsets.only(
                    top: 15,
                  ),
                  width: double.maxFinite,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data["creator_details"]["username"],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 4),
                          child: Text(
                            TimeFormatter()
                                .readTimestamp(int.parse(widget.data["time"])),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          )),
                      Spacer(),
                      SizedBox(
                        width: 33,
                        height: 33,
                        child: user_data["id"] ==
                                widget.data["creator_details"]["creator_id"]
                            ? PopupMenuButton(
                                icon: SvgPicture.asset(
                                  "assets/svg/menu-svgrepo-com(1).svg",
                                  height: 21,
                                  width: 21,
                                  fit: BoxFit.scaleDown,
                                  color: Color.fromARGB(255, 206, 23, 23),
                                ),
                                itemBuilder: (ctx) {
                                  return [
                                    PopupMenuItem(
                                      value: 'Delete',
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 33,
                                            height: 33,
                                            decoration: const BoxDecoration(
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
                                            "Delete",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 46, 46, 46),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                offset: const Offset(0, 40),
                                onSelected: (value) {
                                  Posts()
                                      .delete_post(widget.data["id"])
                                      .then((value) => {
                                            if (value == 1)
                                              {
                                                setState(() {
                                                  widget.onSonChanged(int.parse(
                                                      widget.data["id"]));
                                                  showToast(
                                                      "You've successfully deleted a post");
                                                  //  Get.back(canPop: mounted);
                                                  // Get.to(Landing(title: ""));
                                                })
                                              }
                                            else
                                              {
                                                showToast(
                                                    "Sorry we couldn't do that! Try again"),
                                              }
                                          });
                                })
                            : PopupMenuButton(itemBuilder: (ctx) {
                                return [
                                  PopupMenuItem(
                                    value: 'Report',
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 33,
                                          height: 33,
                                          decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromARGB(
                                                  255, 240, 131, 30)),
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
                                          "Report",
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 46, 46, 46),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ];
                              }),
                      ),
                    ],
                  ),
                )),
              ]),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    child: Text(
                      widget.data["creator_details"]["state"],
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF5555),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Image.asset(
                      "assets/images/star-dynamic-gradient.png",
                      height: 21,
                      width: 21,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Text(
                      widget.data["creator_details"]["preference"],
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF5555),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Container(
                    child: Image.asset(
                      "assets/images/travel-front-gradient.png",
                      height: 21,
                      width: 21,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  ClipOval(
                      child: Container(
                    height: 20,
                    width: 20,
                    child: Center(
                        child: Text(
                      widget.data["creator_details"]["gender"] == "male"
                          ? "M"
                          : "F",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800),
                    )),
                    decoration: BoxDecoration(
                        color: Color(0xFFFF5555), shape: BoxShape.circle),
                  )),
                  SizedBox(
                    width: 8,
                  ),
                  ClipOval(
                      child: Container(
                    height: 20,
                    width: 20,
                    child: Center(
                        child: Image.asset(widget.data["creator_details"]
                                    ["gender"] ==
                                "male"
                            ? "assets/images/cute-color-vector-illustration-beard-afro-black-guy-face-avatar-positive-young-black-guy-smiling-87383651.jpg"
                            : "assets/images/pngtree-personality-avatar-black-women-illustration-elements-png-image_2352544-removebg-preview.png")),
                    decoration: BoxDecoration(
                        // color: Color.fromARGB(255, 219, 48, 5),
                        shape: BoxShape.circle),
                  )),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(height: 3),
              widget.data["post_type"] == "IMAGE"
                  ? Container(
                      height: 450,
                      width: double.maxFinite,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 450.0,
                          initialPage: 0,
                          //aspectRatio: 16 / 9,
                          autoPlay: true,
                          onPageChanged: (val, _) {
                            setState(() {
                              dots_indicator_position = val.toDouble();
                            });
                          },
                          autoPlayInterval: Duration(seconds: 10),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          viewportFraction: 1.0,
                        ),
                        items: media_files.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                  onTap: (() {
                                    Get.to(ViewPicture(
                                      fileUrl: i,
                                      media_source: "post",
                                    ));
                                  }),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: Get.height * 1.0,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 1.0),
                                    child: ImageFade(
                                      image: NetworkImage(
                                          "http://statup.ng/room8/room8/media/posts/images/" +
                                              i),
                                      duration:
                                          const Duration(milliseconds: 900),
                                      syncDuration:
                                          const Duration(milliseconds: 150),

                                      alignment: Alignment.center,

                                      fit: BoxFit.cover,
                                      placeholder: Container(
                                        color: Color(0xFFFFD390),
                                        alignment: Alignment.center,
                                      ),
                                      loadingBuilder: (context, progress,
                                              chunkEvent) =>
                                          Center(
                                              child: CircularProgressIndicator(
                                        value: progress,
                                        strokeWidth: 0.2,
                                        color: Colors.white,
                                      )),

                                      // displayed when an error occurs:
                                      errorBuilder: (context, error) =>
                                          Container(
                                        color: Color(0xFFFFD390),
                                        alignment: Alignment.center,
                                        child: const Icon(Icons.warning,
                                            color: Color.fromARGB(
                                                242, 255, 255, 255),
                                            size: 128.0),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                  ));
                            },
                          );
                        }).toList(),
                      ))
                  : media_files == null
                      ? Text("")
                      : media_files.isNotEmpty &&
                              widget.data["post_type"] == "VIDEO"
                          ? VisibilityDetector(
                              key: Key('my_widget'),
                              onVisibilityChanged: (VisibilityInfo info) {
                                if (info.visibleFraction == 1.0) {
                                  _controller!.play();
                                } else {
                                  _controller!.pause();
                                }
                              },
                              child: Container(
                                  height: 300,
                                  child: FutureBuilder(
                                    future: _initializeVideoPlayerFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        // If the VideoPlayerController has finished initialization, use
                                        // the data it provides to limit the aspect ratio of the video.
                                        return AspectRatio(
                                          aspectRatio:
                                              _controller!.value.aspectRatio *
                                                  9,
                                          // Use the VideoPlayer widget to display the video.
                                          child: VideoPlayer(_controller!),
                                        );
                                      } else {
                                        // If the VideoPlayerController is still initializing, show a
                                        // loading spinner.
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  )))
                          : Container(),
              SizedBox(
                height: 3,
              ),

              Center(
                  child: media_files != null
                      ? media_files.length > 1
                          ? DotsIndicator(
                              dotsCount: media_files.length,
                              position: dots_indicator_position == null
                                  ? 0.0
                                  : dots_indicator_position,
                              decorator: DotsDecorator(
                                color: Colors.black87, // Inactive color
                                activeColor: Colors.redAccent,

                                spacing: const EdgeInsets.all(2.0),
                              ),
                            )
                          : SizedBox()
                      : SizedBox()),

//display media from user post

              SizedBox(height: 15),
              Container(
                  margin: EdgeInsets.only(left: 14, right: 14),
                  child: HashTagDetector().convertHashtag(
                      widget.data["content"].toString(),
                      media_files,
                      text_expand!)),
              (widget.data["content"].toString().split('').length > 60 &&
                          text_expand == false) ||
                      text_expand == null
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          text_expand = true;
                        });
                      },
                      //handle display of less and more buttons to show or hide more text content
                      child: Container(
                          margin: EdgeInsets.only(left: 14, right: 14),
                          child: Text("More...",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red))))
                  : widget.data["content"].toString().split('').length > 100 &&
                          text_expand == true
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              text_expand = !text_expand!;
                            });
                          },
                          child: Container(
                              margin: EdgeInsets.only(left: 14, right: 14),
                              child: Text("Less...",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red))))
                      : SizedBox(
                          width: 10,
                          height: 6,
                        ),

              SizedBox(
                height: 10,
              ),

              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset(
                    "assets/svg/views.svg",
                    height: 21,
                    width: 21,
                    fit: BoxFit.scaleDown,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  SizedBox(width: 3),
                  Text(
                    NumberFormat.compact()
                        .format(int.parse(widget.data["views_count"])),
                    style: TextStyle(color: Color.fromARGB(255, 92, 92, 92)),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Get.to(Comments(
                        post: widget.data,
                        isFollowed: false,
                      ));
                    },
                    child: SvgPicture.asset(
                      "assets/svg/comments1.svg",
                      height: 21,
                      width: 21,
                      fit: BoxFit.scaleDown,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(width: 3),
                  Text(widget.data["comments_count"],
                      style: TextStyle(color: Color.fromARGB(255, 92, 92, 92))),
                  SizedBox(width: 10),
                  SvgPicture.asset(
                    "assets/svg/share.svg",
                    height: 21.sp,
                    width: 21.sp,
                    fit: BoxFit.scaleDown,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    "assets/svg/gift-svgrepo-com(1).svg",
                    height: 21.sp,
                    width: 21.sp,
                    fit: BoxFit.scaleDown,
                    //  color: Color.fromARGB(255, 0, 0, 0),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Divider(
                height: 1,
                color: Color.fromARGB(255, 194, 194, 194),
              )
            ]));
  }
}
