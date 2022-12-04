import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:roomnew/components/time_formater.dart';
import 'package:roomnew/screens/comments.dart';
import 'package:roomnew/screens/landing.dart';
import 'package:roomnew/screens/profile.dart';
import 'package:roomnew/screens/view_picture.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:image_fade/image_fade.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/timeago.dart';
import '../services/posts.dart';
import '../services/users.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import '../components/toast.dart';
import 'package:hive/hive.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roomnew/components/hashtag_detector.dart';
import 'package:roomnew/components/loading.dart';
import 'package:flutter_svg/flutter_svg.dart';

//declare type dev of callback
typedef void VoidCallback(int id);

class Post extends StatefulWidget {
  const Post(
      {super.key,
      required this.data,
      required this.isFollowed,
      required this.onSonChanged});

  final Map data;
  final bool isFollowed;
  final VoidCallback onSonChanged;

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  double dots_indicator_position = 0.0;
  bool? text_expand = false;
  int? max_lines_for_post;
  bool? isFollow;
  var user_data = Hive.box("room8").get("user_data");

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<dynamic> media_files = widget.data["media"];
    if (isFollow == null)
      isFollow = widget.isFollowed;
    else
      isFollow = isFollow;

    return Container(
        margin: EdgeInsets.only(bottom: 0, top: 10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 5,
                ),
                GestureDetector(
                    onTap: (() {
                      Get.to(Profile(
                        title: "Room8 - Profile",
                        id: widget.data["creator_details"]["creator_id"],
                        profile_img: widget.data["creator_details"]
                            ["profile_image_url"],
                        username: widget.data["creator_details"]["username"],
                      ));
                    }),
                    child: ClipOval(
                        child: Container(
                      height: 40,
                      width: 40,
                      child: ImageFade(
                        image: NetworkImage("https://statup.ng/room8/room8/" +
                            widget.data["creator_details"]
                                ["profile_image_url"]),
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
                        loadingBuilder: (context, progress, chunkEvent) =>
                            Center(
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
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 173, 173, 172),
                          shape: BoxShape.circle),
                    ))),
                SizedBox(width: 5),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        Text(
                          "@" + widget.data["creator_details"]["username"],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 5),
                        Text(
                          TimeFormatter()
                              .readTimestamp(int.parse(widget.data["time"])),
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        SizedBox(width: 12),
                        user_data["id"] ==
                                widget.data["creator_details"]["creator_id"]
                            ? SizedBox()
                            : GestureDetector(
                                onTap: () => ({
                                  Users()
                                      .followUser(
                                          id_to_follow:
                                              widget.data["creator_details"]
                                                  ["creator_id"])
                                      .then((value) => {
                                            if (value == 1)
                                              {
                                                setState(() {
                                                  isFollow = true;
                                                }),
                                                showToast(
                                                    "You just followed a user!"),
                                              }
                                            else if (value == 2)
                                              {
                                                setState(() {
                                                  isFollow = false;
                                                }),
                                                showToast(
                                                    "You just unfollowed a user!"),
                                              }
                                            else if (value == 0)
                                              {
                                                showToast("Operation failed"),
                                              }
                                          })
                                  //}
                                }),
                                child: SvgPicture.asset(
                                  "assets/svg/follow.svg",
                                  height: 17,
                                  width: 17,
                                  fit: BoxFit.scaleDown,
                                  color: isFollow == true
                                      ? Color.fromARGB(255, 104, 15, 1)
                                      : Color.fromARGB(255, 87, 86, 86),
                                ),
                              ),
                      ],
                    )),
                const Spacer(),
                SizedBox(
                  width: 33,
                  height: 33,
                  child: user_data["id"] ==
                          widget.data["creator_details"]["creator_id"]
                      ? PopupMenuButton(
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
                                        color:
                                            Color.fromARGB(255, 255, 225, 91),
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
                                        color: Color.fromARGB(255, 46, 46, 46),
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
                                            widget.onSonChanged(
                                                int.parse(widget.data["id"]));
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
                                        color:
                                            Color.fromARGB(255, 240, 72, 30)),
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
                                      color: Color.fromARGB(255, 46, 46, 46),
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
            SizedBox(height: 5),
            Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(
                    top: widget.data["content"] == "" ? 0 : 20,
                    bottom: 20,
                    left: 0,
                    right: 0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: widget.data["content"] == ""
                            ? SizedBox()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Container(
                                        margin:
                                            EdgeInsets.only(left: 5, right: 5),
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
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                child: Text("More...",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                    margin: EdgeInsets.only(
                                                        left: 5, right: 5),
                                                    child: Text("Less...",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.red))))
                                            : SizedBox()
                                  ])),
                    SizedBox(height: 18),
                    widget.data["post_type"] == "IMAGE"
                        ? Container(
                            height: 360,
                            width: double.maxFinite,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                height: 400.0,
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 1.0),
                                          child: ImageFade(
                                            image: NetworkImage(
                                                "http://statup.ng/room8/room8/media/posts/images/" +
                                                    i),
                                            duration: const Duration(
                                                milliseconds: 900),
                                            syncDuration: const Duration(
                                                milliseconds: 150),

                                            alignment: Alignment.center,

                                            fit: BoxFit.cover,
                                            placeholder: Container(
                                              color: Color(0xFFFFD390),
                                              alignment: Alignment.center,
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
                                ? Container(
                                    height: 300.sp,
                                    width: double.maxFinite,
                                    child: FutureBuilder(
                                      future: VideoThumbnail.thumbnailData(
                                        video:
                                            "https://statup.ng/room8/room8/media/posts/videos/sword-fight-scene.mp4",
                                        imageFormat: ImageFormat.JPEG,
                                        maxWidth: 128,
                                        quality: 100,
                                      ),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snap) {
                                        if (!snap.hasData) {
                                          return SizedBox(
                                            height: 250,
                                            child: loader(),
                                          );
                                        } else {
                                          return Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.memory(
                                                  snap.data,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                  height: 320,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => {},
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    color: Colors.white
                                                        .withOpacity(.3),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Icon(Icons.play_arrow,
                                                      color: Colors.red,
                                                      size: 40),
                                                ),
                                              )
                                            ],
                                          );
                                        }
                                      },
                                    ))
                                : SizedBox(),
                    SizedBox(height: 13),
                    Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.visibility,
                              size: 16,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(widget.data["views_count"]),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: (() {
                                Get.to(Comments(
                                  post: widget.data,
                                  isFollowed: isFollow,
                                ));
                              }),
                              child: SvgPicture.asset(
                                "assets/svg/ask.svg",
                                height: 16,
                                width: 16,
                                fit: BoxFit.scaleDown,
                                color: Color.fromARGB(255, 102, 102, 102),
                              ),
                            ),

                            SizedBox(
                              width: 3,
                            ),
                            Text("80"),
                            SizedBox(
                              width: 10,
                            ),
                            SvgPicture.asset(
                              "assets/svg/hands.svg",
                              height: 21.sp,
                              width: 21.sp,
                              fit: BoxFit.scaleDown,
                              color: Color.fromARGB(255, 102, 102, 102),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            // ignore: unnecessary_null_comparison
                            media_files != null
                                ? media_files.length > 1
                                    ? DotsIndicator(
                                        dotsCount: media_files.length,
                                        position:
                                            dots_indicator_position == null
                                                ? 0.0
                                                : dots_indicator_position,
                                        decorator: DotsDecorator(
                                          color:
                                              Colors.black87, // Inactive color
                                          activeColor: Colors.redAccent,

                                          spacing: const EdgeInsets.all(2.0),
                                        ),
                                      )
                                    : SizedBox()
                                : SizedBox(),
                            Spacer(),
                          ],
                        )),
                  ],
                )

                //rest of the existing code
                )
          ],
        ));
  }
}
