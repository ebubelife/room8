import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hive/hive.dart';
import 'package:image_fade/image_fade.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roomnew/components/user_posts.dart';
import 'package:roomnew/screens/view_picture.dart';
import '../components/loading.dart';
import '../components/post.dart';
import '../services/posts.dart';

class Profile extends StatefulWidget {
  const Profile(
      {super.key,
      required this.title,
      required this.id,
      required this.profile_img,
      required this.username});

  final String title, id, profile_img, username;

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

  @override
  Widget build(BuildContext context) {
    String? username = user_data["username"];
    String? profile_img_url = user_data["profile_image_url"];

    String? follwowingCount = "";
    String? follwowersCount = "";

    print(widget.id);
    print(user_data["id"]);
    return FutureBuilder(
        future: Posts().get_all_users_posts(widget.id),
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

              return Scaffold(
                  body: Container(
                      height: double.maxFinite,
                      width: double.maxFinite,
                      color: Color.fromARGB(255, 252, 250, 249),
                      child: SingleChildScrollView(
                          child: Column(children: [
                        Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(top: 60),
                            child: Row(
                              children: [
                                Spacer(),
                                Center(
                                    child: GestureDetector(
                                        onTap: (() {
                                          Get.to(ViewPicture(
                                            media_source: "profile",
                                              fileUrl: widget.id ==
                                                      user_data["id"]
                                                  ? profile_img_url.toString()
                                                  : widget.profile_img));
                                        }),
                                        child: ClipOval(
                                            child: Container(
                                          height: 78,
                                          width: 70,
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
                                Spacer(),
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
                                          ? user_data["following_count"]
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
                                          ? user_data["follower_count"]
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
                                    ? SvgPicture.asset(
                                        "assets/svg/follow.svg",
                                        height: 19,
                                        width: 19,
                                        fit: BoxFit.scaleDown,
                                        color: 1 != true
                                            ? Color.fromARGB(255, 104, 15, 1)
                                            : Color.fromARGB(255, 87, 86, 86),
                                      )
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
                                  return SizedBox(width: 10.sp);
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return getPosts(
                                    posts[index],
                                  );
                                }))
                      ]))));
            } else if (postsFromRefresh.isNotEmpty) {
              return ListView.separated(
                  shrinkWrap: true,
                  itemCount: posts!.length,
                  scrollDirection: Axis.vertical,
                  primary: false,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (c, i) {
                    return SizedBox(width: 10.sp);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    setState(() {
                      follwowersCount = "5";
                    });

                    return getPosts(
                      posts![index],
                    );
                  });
            } else {
              return Container(
                  margin: EdgeInsets.only(top: 100),
                  child: Center(
                      child: GestureDetector(
                          onTap: (() {
                            Navigator.pop(context); // pop current page
                            Get.to(Profile(
                              title: "Room8 - Home",
                              id: user_data["id"],
                              profile_img: widget.profile_img,
                              username: widget.username,
                            )); // push it back in
                          }),
                          child: Image.asset(
                            "assets/images/man-confusing-due-to-no-connection-error-4558763-3780059.png",
                            height: 360,
                            width: 360,
                          ))));
            }
          }
        });
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
}
