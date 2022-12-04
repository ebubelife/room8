import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:roomnew/components/form_fields.dart';
import 'package:roomnew/components/loading.dart';
import 'package:roomnew/components/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roomnew/screens/landing.dart';
import 'package:roomnew/screens/signup.dart';
import 'package:roomnew/services/auth.dart';

import 'enterOTP.dart';

class sendOTP extends StatefulWidget {
  const sendOTP({super.key, required this.title});

  final String title;

  @override
  State<sendOTP> createState() => _sendOTPState();
}

class _sendOTPState extends State<sendOTP> {
  bool termsCheckBox = true;
  bool _visible = true;

  //text controllers
  TextEditingController username_or_email_controller = TextEditingController();

  bool obscure_password = true;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: AnimatedOpacity(
            // If the widget is visible, animate to 0.0 (invisible).
            // If the widget is hidden, animate to 1.0 (fully visible).
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 2000),
            child: Container(
                color: Colors.red,
                child: SafeArea(
                    child: Container(
                        padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                        height: double.maxFinite,
                        width: double.maxFinite,
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                const Color(0xFFF12A6D),
                                const Color(0xFFFF7922),
                              ],
                              begin: const FractionalOffset(-0.0, -0.5),
                              end: const FractionalOffset(1.0, 0.9),
                              stops: [0.6, 1.0],
                              tileMode: TileMode.clamp),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 60),
                              SizedBox(
                                child: Image.asset("assets/images/logo.PNG",
                                    width: 80, height: 40.sp),
                              ),
                              SizedBox(height: 100),
                              Text(
                                "Enter your username or email here and we will send you a code to recover your account",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.sp),
                              ),
                              CustomField(
                                hint: "Username/Email",
                                controller: username_or_email_controller,
                              ),
                              SizedBox(
                                height: 20.sp,
                              ),
                              GestureDetector(
                                  onTap: (() {
                                    if (username_or_email_controller
                                        .text.isNotEmpty) {
                                      loading2("Loading", context);
                                      Auth()
                                          .sendOTP(
                                            username_or_email:
                                                username_or_email_controller
                                                    .text,
                                          )
                                          .then((value) => {
                                                if (value == 1)
                                                  {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(),
                                                    showToast(
                                                        "An OTP has been sent to your email"),
                                                    Get.offAll(EnterOTP_Password(
                                                        title:
                                                            "Room8 Social - New Password"))
                                                  }
                                                else
                                                  {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(),
                                                    showToast(value),
                                                  }
                                              });
                                    } else {
                                      showToast(
                                          "Please fill ALL fields correctly!");
                                    }
                                  }),
                                  child: Material(
                                      borderRadius: BorderRadius.circular(25.0),
                                      elevation: 10.sp,
                                      shadowColor:
                                          Color.fromARGB(255, 131, 131, 131),
                                      child: Container(
                                          width: double.maxFinite,
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 15),
                                          decoration: BoxDecoration(
                                            color:
                                                Color.fromARGB(255, 37, 37, 37),
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(15.0),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text("Submit",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                          //rest of the existing code
                                          ))),
                              SizedBox(height: 8.sp),
                            ],
                          ),
                        ))))));
  }
}
