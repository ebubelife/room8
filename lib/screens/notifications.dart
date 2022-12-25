import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:image_fade/image_fade.dart';
import 'package:roomnew/screens/comments.dart';
import 'package:roomnew/screens/profile.dart';

import '../components/loading.dart';
import '../components/time_formater.dart';
import '../services/others.dart';
import '../services/posts.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key, required this.title});

  final String title;

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  ScrollController _controller = ScrollController();
  late Future<dynamic> future;
  @override
  void initState() {
    _controller = ScrollController();

    future = _fetchNotifs();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List? notifications = [];
    return Scaffold(
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
                    child: Column(children: [
                      //logo

                      Container(
                          margin: EdgeInsets.only(top: 20, bottom: 10),
                          height: 20,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          width: double.maxFinite,
                          child: GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/back-arrow-svgrepo-com.svg",
                                    height: 21,
                                    width: 21,
                                    //  fit: BoxFit.scaleDown,
                                    color: Colors.red,
                                  ),
                                  SvgPicture.asset(
                                    "assets/svg/ROOM8.svg",
                                    height: 21,
                                    width: 21,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ],
                              ))),
                      SizedBox(
                        height: 10,
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
                                    Hive.box("room8")
                                        .put("notifs", snapshot.data);
                                    notifications =
                                        Hive.box("room8").get("notifs");

                                    return ListView.separated(
                                        shrinkWrap: true,
                                        itemCount: notifications!.length,
                                        scrollDirection: Axis.vertical,
                                        controller: _controller,
                                        primary: false,
                                        physics: const BouncingScrollPhysics(),
                                        separatorBuilder: (c, i) {
                                          return SizedBox(width: 10.sp);
                                        },
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  //on click save new state of notification to cache
                                                  notifications![index]
                                                      ["status"] = "READ";

                                                  //update whole array in data storage
                                                  Hive.box("room8").put(
                                                      "notifs", notifications);
                                                });

                                                notifications![index]["type"] ==
                                                        "FOLLOW"
                                                    ? Get.to(Profile(
                                                        title:
                                                            "Room8 - Profile",
                                                        id: notifications![
                                                                index]
                                                            ["trigger_id"],
                                                        profile_img: notifications![
                                                                index][
                                                            "trigger_profile_image"],
                                                        //add notificaion id to update state of notification on profile actiity

                                                        notif_id:
                                                            notifications![
                                                                index]["id"],
                                                        username: notifications![
                                                                index][
                                                            "trigger_username"],
                                                        isFollowed: true))
                                                    : Get.to(Comments(
                                                        post: notifications![
                                                                index][
                                                            "post_containing_comment"],
                                                        target_comment:
                                                            notifications![
                                                                    index]
                                                                ["comment_id"],
                                                        isFollowed: true,
                                                        notif_id:
                                                            notifications![
                                                                index]["id"],
                                                      ));
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 5, right: 5),
                                                  child: Row(
                                                    children: [
                                                      ClipOval(
                                                          child: Container(
                                                        height: 60,
                                                        width: 60,
                                                        child: ImageFade(
                                                          image: NetworkImage(
                                                              "https://statup.ng/room8/room8/" +
                                                                  notifications![
                                                                          index]
                                                                      [
                                                                      "trigger_profile_image"]),
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      900),
                                                          syncDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      150),

                                                          alignment:
                                                              Alignment.center,

                                                          fit: BoxFit.cover,
                                                          placeholder:
                                                              Container(
                                                            color: const Color(
                                                                0xFFCFCDCA),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Icon(
                                                                Icons.photo,
                                                                color: Colors
                                                                    .white30,
                                                                size: 128.0),
                                                          ),
                                                          loadingBuilder: (context,
                                                                  progress,
                                                                  chunkEvent) =>
                                                              Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                            value: progress,
                                                            strokeWidth: 0.2,
                                                            color: Colors.white,
                                                          )),

                                                          // displayed when an error occurs:
                                                          errorBuilder:
                                                              (context,
                                                                      error) =>
                                                                  Container(
                                                            color: const Color(
                                                                0xFF6F6D6A),
                                                            alignment: Alignment
                                                                .center,
                                                            child: const Icon(
                                                                Icons.warning,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        255,
                                                                        220,
                                                                        63),
                                                                size: 128.0),
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        173,
                                                                        173,
                                                                        172),
                                                                shape: BoxShape
                                                                    .circle),
                                                      )),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              // Note: Styles for TextSpans must be explicitly defined.
                                                              // Child text spans will inherit styles from parent
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold),
                                                                    text: notifications![
                                                                            index]
                                                                        [
                                                                        "trigger_username"]),
                                                                TextSpan(
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                    text: notifications![index]["type"] ==
                                                                            "FOLLOW"
                                                                        ? " followed you."
                                                                        : " commented on your post.")
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            TimeFormatter()
                                                                .readTimestamp(int.parse(
                                                                    notifications![
                                                                            index]
                                                                        [
                                                                        "time"])),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  height: 80,
                                                  width: double.maxFinite,
                                                  decoration: BoxDecoration(
                                                    color: notifications![index]
                                                                ["status"] ==
                                                            "UNREAD"
                                                        ? Color.fromARGB(255,
                                                                255, 244, 212)
                                                            .withOpacity(0.4)
                                                        : Color(0xFFF1F1F1)
                                                            .withOpacity(0.4),
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          width: 1.0,
                                                          color: Color.fromARGB(
                                                              255,
                                                              228,
                                                              228,
                                                              228)),
                                                    ),
                                                  )));
                                        });
                                  } else {
                                    return Container(
                                        child: Center(
                                            child: Text(
                                      "No notifications yet! They will appear here when people interracting with you.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    )));
                                  }
                                }
                                ;
                              }))
                    ])))));
  }

  Future<dynamic> _fetchNotifs() async {
    var data = Others().get_notifs();

    return data;
  }
}
