import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_fade/image_fade.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key, required this.title});

  final String title;

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  ScrollController _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
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
                              onTap: () {},
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/home-svgrepo-com(1).svg",
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
                        child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: 20,
                            scrollDirection: Axis.vertical,
                            controller: _controller,
                            primary: false,
                            physics: const BouncingScrollPhysics(),
                            separatorBuilder: (c, i) {
                              return SizedBox(width: 10.sp);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Row(
                                    children: [
                                      ClipOval(
                                          child: Container(
                                        height: 60,
                                        width: 60,
                                        child: ImageFade(
                                          image: NetworkImage(
                                              "https://lumiere-a.akamaihd.net/v1/images/p_avatar_de27b20f.jpeg"),
                                          duration:
                                              const Duration(milliseconds: 900),
                                          syncDuration:
                                              const Duration(milliseconds: 150),

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
                                      )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "Cloodhus commented on your post"),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text("20 minutes ago")
                                        ],
                                      )
                                    ],
                                  ),
                                  height: 80,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    color: index % 2 == 0
                                        ? Color.fromARGB(255, 255, 244, 212)
                                            .withOpacity(0.4)
                                        : Color(0xFFF1F1F1).withOpacity(0.4),
                                    border: Border(
                                      bottom: BorderSide(
                                          width: 1.0,
                                          color: Color.fromARGB(
                                              255, 228, 228, 228)),
                                    ),
                                  ));
                            }),
                      )
                    ])))));
  }
}
