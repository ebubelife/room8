import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../components/loading.dart';
import '../components/post.dart';
import '../services/posts.dart';
import 'landing.dart';
import 'dart:async';
import 'package:async/async.dart';

import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class MainHome extends StatefulWidget {
  MainHome(
      {Key? key,
      required this.title,
      required this.offset,
      required this.mainHomeController})
      : super(key: key);

  final String title;
  final int offset;
  final MainHomeController mainHomeController;

  final GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  @override
  State<MainHome> createState() => _MainHomeState(mainHomeController);
}

@override
bool get wantKeepAlive => true;

class _MainHomeState extends State<MainHome>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ScrollController _controller = ScrollController();
  int swipeCount = 0;
  int? pid;
  late final Future _future;
  List? posts = [];
  bool show_top_strip = false;

  late Future<dynamic> future;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    future = _fetchData();

    super.initState();
  }

  //pull to refresh screen
  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 0));

    setState(() {
      future = _fetchData();
    });

    return null;
  }

  _scrollListener() {
    /* if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        print("reach the bottom");
      });
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      setState(() {
        if (swipeCount > 0) {
          // refreshList();
        }
        swipeCount++;
      });
    }*/
  }

  _MainHomeState(MainHomeController _controller) {
    _controller.scrollUp = scrollUp;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool _visible = true;
    var postsFromRefresh = [];
    int _selectedIndex = 0;
    List? posts = [];

    var refreshKey = GlobalKey<RefreshIndicatorState>();

    //pull to refresh screen removed for poor UX
    /* Future<Null> refreshList() async {
      refreshKey.currentState?.show(atTop: false);
      await Future.delayed(Duration(seconds: 2));

      Navigator.pop(context); // pop current page
      Get.to(Landing(title: "Room8 - Home")); // push it back in

      return null;
    }
*/
    return Scaffold(
      backgroundColor: Colors.white,
//                  appBar: AppBar(),
      body: Stack(
        children: [
          Container(
              color: Color.fromARGB(255, 255, 255, 255),
              height: double.maxFinite,
              child: SafeArea(
                child: Container(
                    height: double.maxFinite,
                    width: double.maxFinite,
                    padding: EdgeInsets.all(0),
                    color: Color.fromARGB(255, 255, 255, 255),
                    //get all posts for user
                    child: Column(
                      children: [
                        //logo

                        Align(
                          child: Image.asset("assets/images/logo.PNG",
                              width: 90, height: 30),
                          alignment: Alignment.topLeft,
                        ),

                        Expanded(
                            child: FutureBuilder(
                                future: future,
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(child: loader());
                                  } else {
                                    if (snapshot.data.isNotEmpty &&
                                        snapshot.data != null &&
                                        snapshot.data != "failed") {
                                      posts = snapshot.data;
//retrieve profile details of user from cache

                                      return RefreshIndicator(
                                          onRefresh: (() => refreshList()),
                                          color:
                                              Color.fromARGB(255, 253, 102, 14),
                                          child: ListView.separated(
                                              shrinkWrap: true,
                                              itemCount: posts!.length,
                                              controller: _controller,
                                              scrollDirection: Axis.vertical,
                                              primary: false,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              separatorBuilder: (c, i) {
                                                return SizedBox(width: 10.sp);
                                              },
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return getPosts(
                                                    posts![index],
                                                    posts![index]
                                                            ["creator_details"]
                                                        ["isFollow"]);
                                              }));
                                    } else if (postsFromRefresh.isNotEmpty) {
                                      posts = postsFromRefresh;
                                      return ListView.separated(
                                          shrinkWrap: true,
                                          itemCount: posts!.length,
                                          scrollDirection: Axis.vertical,
                                          controller: _controller,
                                          primary: false,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          separatorBuilder: (c, i) {
                                            return SizedBox(width: 10.sp);
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return getPosts(
                                                posts![index],
                                                posts![index]["creator_details"]
                                                    ["isFollow"]);
                                          });
                                    } else {
                                      return Container(
                                          margin: EdgeInsets.only(top: 100),
                                          child: Center(
                                              child: GestureDetector(
                                                  onTap: (() {
                                                    Navigator.pop(
                                                        context); // pop current page
                                                    Get.to(Landing(
                                                        title:
                                                            "Room8 - Home")); // push it back in
                                                  }),
                                                  child: Image.asset(
                                                    "assets/images/man-confusing-due-to-no-connection-error-4558763-3780059.png",
                                                    height: 360,
                                                    width: 360,
                                                  ))));
                                    }
                                  }
                                })),

                        SizedBox(height: 5)
                      ],
                    )),
              )),
          /*  show_top_strip == true
              ? Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: 50),
                  child: Row(children: [
                    Spacer(),
                    Container(
                      child: Stack(children: [
                        Positioned(
                            left: 150.0,
                            child: GestureDetector(
                                onTap: (() {
                                  refreshList();
                                }),
                                child: Container(
                                  child: Icon(
                                    Icons.refresh,
                                    color: Color.fromARGB(255, 192, 73, 3),
                                  ),
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                ))),
                        Positioned(
                            right: 120.0,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                            )),
                        Positioned(
                            right: 90.0,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                            )),
                        Positioned(
                            right: 60.0,
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                            )),
                        Positioned(
                            left: 5.0,
                            child: GestureDetector(
                                onTap: () {
                                  scrollUp();
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.arrow_circle_up_sharp,
                                    color: Color.fromARGB(255, 192, 73, 3),
                                  ),
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Colors.grey)),
                                ))),
                      ]),
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          color: Color.fromARGB(255, 100, 100, 100)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                    Spacer(),
                  ]),
                )
              : SizedBox()*/
        ],
      ),
    );
  }

  Widget getPosts(Map posts, bool isFollow) {
    return Post(
      data: posts,
      isFollowed: isFollow,
      //pass method to child widget through the call back
      onSonChanged: (id) => {remove_item_from_list()},
    );
  }

//create method to remove item from list when data is changed in child
  void remove_item_from_list() {
    setState(() {
       future = _fetchData();
      print("eliminated");
    });
  }

  void scrollUp() {
    _controller.animateTo(
      widget.offset.toDouble(),
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  Future<dynamic> _fetchData() async {
    var o = Posts().get_all_posts();

    print(o.toString());

    return o;
  }
}
