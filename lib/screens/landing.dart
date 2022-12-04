import 'package:image_fade/image_fade.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'dart:math';
import 'package:roomnew/components/loading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roomnew/screens/comments.dart';
import 'package:roomnew/screens/mainhome.dart';
import 'package:roomnew/screens/new_post.dart';
import 'package:roomnew/screens/profile.dart';
import 'package:roomnew/screens/search.dart';

import '../components/post.dart';
import '../components/timeago.dart';
import '../services/posts.dart';

class Landing extends StatefulWidget {
  const Landing({super.key, required this.title});

  final String title;

  @override
  State<Landing> createState() => _LandingState();
}

@override
bool get wantKeepAlive => true;

class _LandingState extends State<Landing> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _visible = true;
  var postsFromRefresh = [];
  int _selectedIndex = 2;
  List? posts = [];
  MyCustomMessages myCustomMessages = new MyCustomMessages();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  var user_data = Hive.box("room8").get("user_data");

  // add
  final pageController = PageController(initialPage: 2);
  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //pull to refresh screen
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    Navigator.pop(context); // pop current page
    Get.to(Landing(title: "Room8 - Home")); // push it back in

    return null;
  }

 

  @override
  Widget build(BuildContext context) {
    super.build(context);
    List<Widget> _pages = [
      Search(title: "Room8 Social - search"),
      Search(title: "Room8 Social - search"),
      MainHome(title: ""),
      Search(title: "Room8 Social - search"),
      Profile(
        title: "",
        id: user_data["id"],
        profile_img: "/",
        username: "",
      ),
    ];
    String? profile_img_url = user_data["profile_image_url"];
    return 
        Scaffold(
            floatingActionButton: Container(
              height: 60.0,
              width: 60.0,
              child: FittedBox(
                child: FloatingActionButton(
                  onPressed: () {
                    Get.to(NewPost(title: "Room8 Social - Post"));
                  },
                  backgroundColor: Color(0xfff75941),
                  child: Icon(Icons.add, size: 35, color: Colors.white),
                ),
              ),
            ),


            bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(
                    //  canvasColor: Color.fromARGB(0, 255, 255, 255),
                    primaryColor: Colors.red,
                    textTheme: Theme.of(context)
                        .textTheme
                        .copyWith(caption: TextStyle(color: Colors.white))),
                child: Container(
                    color: Colors.white,
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: BottomNavigationBar(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          type: BottomNavigationBarType.fixed,
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          selectedItemColor: Colors.orange,
                          unselectedItemColor: Colors.grey,
                          items: <BottomNavigationBarItem>[
                            BottomNavigationBarItem(
                              activeIcon: Icon(
                                Icons.notifications_outlined,
                                size: 30,
                                color: Colors.orange,
                              ),
                              label: 'search',
                              icon: Icon(
                                Icons.notifications_outlined,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                            BottomNavigationBarItem(
                              activeIcon: Icon(
                                Icons.search_sharp,
                                size: 30,
                                color: Colors.orange,
                              ),
                              label: 'search',
                              icon: Icon(
                                Icons.search_sharp,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                            BottomNavigationBarItem(
                              activeIcon: Icon(
                                Icons.home_filled,
                                size: 30,
                                color: Colors.orange,
                              ),
                              icon: Icon(
                                Icons.home_filled,
                                size: 30,
                                color: Colors.grey,
                              ),
                              label: 'home',
                            ),
                            BottomNavigationBarItem(
                              activeIcon: Icon(
                                Icons.numbers,
                                size: 30,
                                color: Colors.orange,
                              ),
                              label: 'search',
                              icon: Icon(
                                Icons.numbers,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                            BottomNavigationBarItem(
                              icon: ClipOval(
                                  child: Container(
                                height: 30,
                                width: 30,
                                child: ImageFade(
                                  image: NetworkImage(
                                      "https://statup.ng/room8/room8/" +
                                          profile_img_url!),
                                  duration: const Duration(milliseconds: 900),
                                  syncDuration:
                                      const Duration(milliseconds: 150),

                                  alignment: Alignment.center,

                                  fit: BoxFit.cover,
                                  placeholder: Container(
                                    color: const Color(0xFFCFCDCA),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.photo,
                                        color: Colors.white30, size: 128.0),
                                  ),
                                  loadingBuilder:
                                      (context, progress, chunkEvent) => Center(
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
                                        color:
                                            Color.fromARGB(255, 255, 220, 63),
                                        size: 128.0),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 173, 173, 172),
                                    shape: BoxShape.circle),
                              )),
                              label: 'Profile',
                            ),
                          ],
                          currentIndex: _selectedIndex,
                          onTap: (int index) {
          // setState(() {
          //   _currentIndex = index;
          // });
          // update
          pageController.jumpToPage(index);
        },
                        )))),
            body: PageView(
        children: _pages,
        controller: pageController,
        
        onPageChanged: onPageChanged,
      ), );
  }

  Widget getPosts(Map posts, bool isFollow) {
    return Post(
      data: posts,
      isFollowed: isFollow,
      onSonChanged: (id) => {},
    );
  }
}
