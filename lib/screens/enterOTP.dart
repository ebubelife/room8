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

class EnterOTP_Password extends StatefulWidget {
  const EnterOTP_Password({super.key, required this.title});

  final String title;

  @override
  State<EnterOTP_Password> createState() => _EnterOTP_PasswordState();
}

class _EnterOTP_PasswordState extends State<EnterOTP_Password> {
  bool termsCheckBox = true;
  bool _visible = true;

  //text controllers
  TextEditingController otp = TextEditingController();
  TextEditingController new_password = TextEditingController();

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
                                "An OTP has been sent to your email. Please enter it here.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.sp),
                              ),
                              CustomField(
                                hint: "Enter code",
                                controller: otp,
                              ),
                              SizedBox(
                                height: 10.sp,
                              ),
                              CustomField(
                                hint: "New Password",
                                controller: new_password,
                                obscureText: true,
                              ),
                              SizedBox(
                                height: 20.sp,
                              ),
                              GestureDetector(
                                  onTap: (() {
                                    if (otp.text.isNotEmpty &&
                                        new_password.text.isNotEmpty) {
                                      loading2("Loading", context);
                                      Auth()
                                          .change_password(
                                            otp: otp.text,
                                            new_password: new_password.text,
                                          )
                                          .then((value) => {
                                                if (value == 1)
                                                  {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(),
                                                    showToast(
                                                        "Your account has been recovered successfully!"),
                                                    Get.offAll(Landing(
                                                        title:
                                                            "Room8 Social - Home"))
                                                  }
                                                else
                                                  {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(),
                                                    showToast(value)
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
