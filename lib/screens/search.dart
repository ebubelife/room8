import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../components/form_fields.dart';
import '../services/others.dart';

class Search extends StatefulWidget {
  const Search({super.key, required this.title});

  final String title;

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  ScrollController _controller = ScrollController();
  TextEditingController search_controller = TextEditingController();
  var searched_profiles = [];

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Color(0xFFF1F1F1).withOpacity(0.4),
            elevation: 0.0,
            // ignore: prefer_const_literals_to_create_immutables

            title: const Text(
              "Search People",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            )),
        body: Container(
            color: Color(0xFFF1F1F1).withOpacity(0.4),
            height: double.maxFinite,
            child: SafeArea(
                child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    padding: EdgeInsets.all(0),
                    color: Color(0xFFF1F1F1).withOpacity(0.4),
                    //get all posts for user
                    child: SingleChildScrollView(
                        child: Column(children: [
                      //logo

                      SizedBox(
                        height: 3,
                      ),

                      Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: SearchField(
                              controller: search_controller,
                              onsubmitted: (value) {
                                //   print(value.toString());

                                Others()
                                    .search_for_user(search_term: value)
                                    .then((value) => {
                                          if (value != null && value.isNotEmpty)
                                            {
                                              setState(() {
                                                searched_profiles = value;
                                              })
                                            }
                                        });
                              },
                              prefixIcon: IconButton(
                                  onPressed: (() {}),
                                  icon: SvgPicture.asset(
                                    "assets/svg/search-svgrepo-com(1).svg",
                                    height: 21,
                                    width: 21,
                                    //  fit: BoxFit.scaleDown,
                                  )))),

                      SizedBox(
                        height: 20,
                      ),

                      Center(
                        child: Text(
                          "Type in a name to search for a room8",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      searched_profiles.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              itemCount: searched_profiles.length,
                              scrollDirection: Axis.vertical,
                              controller: _controller,
                              primary: false,
                              physics: const BouncingScrollPhysics(),
                              separatorBuilder: (c, i) {
                                return SizedBox(width: 10.sp);
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                    color: Color.fromARGB(255, 238, 238, 238),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            ClipOval(
                                                child: Container(
                                              color: Colors.white,
                                              child: Image.network(
                                                "https://wallpapers.com/images/file/squinting-and-pointing-down-cr7-3d-rn7gwe2ohsj45gr1.jpg",
                                                height: 50,
                                                width: 50,
                                              ),
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      searched_profiles[index]
                                                          ["username"],
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Container(
                                                      child: Text(
                                                        searched_profiles[index]
                                                                    [
                                                                    "isFollowed"] ==
                                                                true
                                                            ? "Following"
                                                            : "Follow",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    8)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            offset: Offset(0,
                                                                2), // changes position of shadow
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Row(
                                                  children: [
                                                    //Display followers count in search card of user profile
                                                    Text(
                                                      searched_profiles[index][
                                                              "followers_count"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text("Followers"),

                                                    //space
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    //

                                                    //Display following count in search card of user profile
                                                    Text(
                                                      searched_profiles[index][
                                                              "following_count"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text("Following"),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
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
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFF5555),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
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
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFF5555),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
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
                                                  color: Color(0xFFFF5555),
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
                                                  child: Image.asset(1 == 1
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
                              })
                          : SizedBox(),
                      SizedBox(
                        height: 20,
                      )
                    ]))))));
  }
}
