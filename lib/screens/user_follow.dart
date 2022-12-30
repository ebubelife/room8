import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:roomnew/screens/landing.dart';
import 'package:roomnew/screens/profile.dart';
import '../components/form_fields.dart';
import '../components/loading.dart';
import '../components/toast.dart';
import '../services/others.dart';
import '../services/users.dart';

class User_follow extends StatefulWidget {
  const User_follow({super.key, required this.title});

  final String title;

  @override
  State<User_follow> createState() => _User_followState();
}

class _User_followState extends State<User_follow> {
  ScrollController _controller = ScrollController();
  TextEditingController search_controller = TextEditingController();
  var searched_profiles = [];
  String? follwowingCount = "5";
  String? follwowersCount = "10";
  late final Future _future;
  int followCount = 0;

  var user_data = Hive.box("room8").get("user_data");

  @override
  void initState() {
    _future = _fetchData();

    user_data = Hive.box("room8").get("user_data");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
            height: 40.0,
            width: 40.0,
            child: FittedBox(
                child: FloatingActionButton(
              onPressed: () {
                if (followCount > 1) {
                  user_data["following_count"] = followCount.toString();
                  Get.to(Landing(title: "Room8 - Home"));
                } else {
                  showToast("Please follow at least 2 users to proceed");
                }
              },
              backgroundColor: Color.fromARGB(255, 0, 0, 0),
              child: Icon(Icons.check, size: 30, color: Colors.white),
            ))),
        body: Container(
            color: Color(0xFFF1F1F1).withOpacity(0.4),
            height: double.maxFinite,
            child: SafeArea(
                child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    color: Color(0xFFF1F1F1).withOpacity(0.4),
                    //get all posts for user
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Center(
                          child: Text(
                              "Please follow a few user profiles to customise and fill up your feed",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 20))),
                      //logo

                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                          future: _future,
                          builder: (context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: loader());
                            } else {
                              if (snapshot.data.isNotEmpty &&
                                  snapshot.data != null &&
                                  snapshot.data != "failed") {
                                searched_profiles = snapshot.data;

                                return ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: searched_profiles.length,
                                    scrollDirection: Axis.vertical,
                                    controller: _controller,
                                    primary: false,
                                    physics: const BouncingScrollPhysics(),
                                    separatorBuilder: (c, i) {
                                      return SizedBox(width: 10.sp);
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      follwowersCount = searched_profiles[index]
                                              ["followers_count"]
                                          .toString();

                                      follwowingCount = searched_profiles[index]
                                              ["following_count"]
                                          .toString();
                                      return Container(
                                          color: Color.fromARGB(
                                              255, 238, 238, 238),
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {
                                                        Get.to(Profile(
                                                          title: "User Profile",
                                                          id: searched_profiles[
                                                              index]["id"],
                                                          profile_img:
                                                              searched_profiles[
                                                                      index][
                                                                  "profile_image_url"],
                                                          notif_id: "",
                                                          username:
                                                              searched_profiles[
                                                                      index]
                                                                  ["username"],
                                                          isFollowed:
                                                              searched_profiles[
                                                                      index][
                                                                  "isFollowed"],
                                                        ));
                                                      },
                                                      child: ClipOval(
                                                          child: Container(
                                                        color: Colors.white,
                                                        child: Image.network(
                                                          "https://statup.ng/room8/room8/" +
                                                              searched_profiles[
                                                                      index][
                                                                  "profile_image_url"],
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                      ))),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {
                                                                Get.to(Profile(
                                                                  title:
                                                                      "User Profile",
                                                                  id: searched_profiles[
                                                                          index]
                                                                      ["id"],
                                                                  profile_img:
                                                                      searched_profiles[
                                                                              index]
                                                                          [
                                                                          "profile_image_url"],
                                                                  notif_id: "",
                                                                  username: searched_profiles[
                                                                          index]
                                                                      [
                                                                      "username"],
                                                                  isFollowed: searched_profiles[
                                                                          index]
                                                                      [
                                                                      "isFollowed"],
                                                                ));
                                                              },
                                                              child: Text(
                                                                searched_profiles[
                                                                        index][
                                                                    "username"],
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          searched_profiles[
                                                                          index]
                                                                      ["id"] !=
                                                                  user_data[
                                                                      "id"]
                                                              ? GestureDetector(
                                                                  onTap: () =>
                                                                      ({
                                                                        Users()
                                                                            .followUser(id_to_follow: searched_profiles[index]["id"])
                                                                            .then((value) => {
                                                                                  if (value == 1)
                                                                                    {
                                                                                      setState(() {
                                                                                        followCount++;
                                                                                        //  int new_follow_count = (int.parse(follwowingCount!) + 1);
                                                                                        searched_profiles[index]["isFollowed"] = true;

                                                                                        // future = _fetchData();

                                                                                        //follwowingCount = new_follow_count.toString();
                                                                                      }),
                                                                                      showToast("You just followed a user!"),
                                                                                    }
                                                                                  else if (value == 2)
                                                                                    {
                                                                                      setState(() {
                                                                                        followCount--;
                                                                                        //  int new_follow_count = (int.parse(follwowingCount!) - 1);
                                                                                        searched_profiles[index]["isFollowed"] = true;

                                                                                        // future = _fetchData();

                                                                                        // follwowingCount = new_follow_count.toString();
                                                                                        searched_profiles[index]["isFollowed"] = false;

                                                                                        // future = _fetchData();
                                                                                      }),
                                                                                      showToast("You just unfollowed a user!"),
                                                                                    }
                                                                                  else if (value == 0)
                                                                                    {
                                                                                      showToast("Operation failed"),
                                                                                    }
                                                                                })
                                                                        //}
                                                                      }),
                                                                  child:
                                                                      Container(
                                                                    child: Text(
                                                                      searched_profiles[index]["isFollowed"] ==
                                                                              true
                                                                          ? "Following"
                                                                          : "Follow",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize:
                                                                              11),
                                                                    ),
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            20,
                                                                        vertical:
                                                                            4),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(8)),
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(0.3),
                                                                          spreadRadius:
                                                                              2,
                                                                          blurRadius:
                                                                              2,
                                                                          offset: Offset(
                                                                              0,
                                                                              2), // changes position of shadow
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ))
                                                              : SizedBox()
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      /* Row(
                                                  children: [
                                                    //Display followers count in search card of user profile
                                                    Text(
                                                      follwowersCount
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 61, 61, 61),
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      "Followers",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 61, 61, 61),
                                                      ),
                                                    ),

                                                    //space
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    //

                                                    //Display following count in search card of user profile
                                                    Text(
                                                      follwowingCount
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 61, 61, 61),
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      "Following",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 61, 61, 61),
                                                      ),
                                                    ),
                                                  ],
                                                ),*/
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 50,
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      searched_profiles[index]
                                                          ["state"],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFFF5555),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: Offset(0,
                                                              2), // changes position of shadow
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
                                                  Container(
                                                    child: Text(
                                                      searched_profiles[index]
                                                          ["preference"],
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 11),
                                                    ),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFFF5555),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8)),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 2,
                                                          blurRadius: 2,
                                                          offset: Offset(0,
                                                              2), // changes position of shadow
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
                                                      searched_profiles[index]
                                                                  ["gender"] ==
                                                              "male"
                                                          ? "M"
                                                          : "F",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    )),
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFFFF5555),
                                                        shape: BoxShape.circle),
                                                  )),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  ClipOval(
                                                      child: Container(
                                                    height: 20,
                                                    width: 20,
                                                    child: Center(
                                                        child: Image.asset(1 ==
                                                                1
                                                            ? "assets/images/cute-color-vector-illustration-beard-afro-black-guy-face-avatar-positive-young-black-guy-smiling-87383651.jpg"
                                                            : "assets/images/pngtree-personality-avatar-black-women-illustration-elements-png-image_2352544-removebg-preview.png")),
                                                    decoration: BoxDecoration(
                                                        // color: Color.fromARGB(255, 219, 48, 5),
                                                        shape: BoxShape.circle),
                                                  )),
                                                ],
                                              )
                                            ],
                                          ));
                                    });
                              } else {
                                return Container(
                                    margin: EdgeInsets.only(top: 100),
                                    child: Center(
                                        child: GestureDetector(
                                            onTap: (() {
                                              _future =
                                                  _fetchData(); // push it back in
                                            }),
                                            child: Image.asset(
                                              "assets/images/man-confusing-due-to-no-connection-error-4558763-3780059.png",
                                              height: 360,
                                              width: 360,
                                            ))));
                              }
                            }
                          }),

                      SizedBox(
                        height: 50,
                      )
                    ]))))));
  }

//get selected members to be followed by new user
  Future<dynamic> _fetchData() async {
    var data = Users().get_selected_users();

    return data;
  }
}
