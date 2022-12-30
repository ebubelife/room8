import 'package:flutter/material.dart';

import 'package:roomnew/components/form_fields.dart';
import 'package:roomnew/components/loading.dart';
import 'package:roomnew/components/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roomnew/screens/landing.dart';
import 'package:roomnew/screens/sentOTP.dart';
import 'package:roomnew/screens/signup.dart';
import 'package:roomnew/screens/user_follow.dart';
import 'package:roomnew/services/auth.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title, required this.from_signup});

  final String title;
  final bool from_signup;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool termsCheckBox = true;
  bool _visible = true;

  //text controllers
  TextEditingController username_or_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

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
                              CustomField(
                                hint: "Username/Email",
                                controller: username_or_controller,
                              ),
                              CustomField(
                                hint: "Password",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() =>
                                        obscure_password = !obscure_password);
                                  },
                                  icon: Icon(
                                      obscure_password
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                      size: 20),
                                ),
                                controller: password_controller,
                                obscureText: obscure_password,
                              ),
                              SizedBox(
                                height: 20.sp,
                              ),
                              GestureDetector(
                                  onTap: (() {
                                    if (username_or_controller
                                            .text.isNotEmpty &&
                                        password_controller.text.isNotEmpty) {
                                      loading2("Loading", context);
                                      Auth()
                                          .login(
                                              username_or_email:
                                                  username_or_controller.text,
                                              password:
                                                  password_controller.text)
                                          .then((value) => {
                                                if (value == 1)
                                                  {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(),
                                                    showToast("Hello, welcome"),
                                                    if (widget.from_signup ==
                                                        false)
                                                      {
                                                        Get.offAll(Landing(
                                                            title:
                                                                "Room8 Social - Home"))
                                                      }
                                                    else
                                                      {
                                                        Get.offAll(User_follow(
                                                            title:
                                                                "Room8 Social - follow users"))
                                                      }
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
                                            child: Text("Sign In",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                          //rest of the existing code
                                          ))),
                              SizedBox(height: 8.sp),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(sendOTP(
                                        title: "Create Account - Room8"));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: 8.sp, bottom: 10.sp),
                                      child: RichText(
                                        softWrap: true,
                                        maxLines: 2,
                                        text: TextSpan(
                                          // Note: Styles for TextSpans must be explicitly defined.
                                          // Child text spans will inherit styles from parent
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Forgot password?',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 77, 77, 77),
                                                    fontSize: 14)),
                                            TextSpan(
                                                text: 'Recover ',
                                                style: const TextStyle()),
                                          ],
                                        ),
                                      ))),
                              SizedBox(height: 8.sp),
                              Row(
                                children: [
                                  Container(
                                    height: 1,
                                    width: Get.width * 0.4,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 7),
                                  Text("OR",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp)),
                                  SizedBox(width: 7),
                                  Container(
                                    height: 1,
                                    width: Get.width * 0.4,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.sp),
                              Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.only(
                                    left: 20, top: 9, bottom: 9, right: 20),
                                margin: EdgeInsets.only(left: 40, right: 50),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/google-icon-removebg-preview.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(width: 24.sp),
                                    Center(
                                        child: Text("Continue with Google",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white)))
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        width: 1, color: Colors.white)),
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.only(
                                    left: 20, top: 9, bottom: 9, right: 20),
                                margin: EdgeInsets.only(left: 40, right: 50),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/apple-icon-2-removebg-preview.png",
                                      width: 20,
                                      height: 20,
                                    ),
                                    SizedBox(width: 26.sp),
                                    Center(
                                        child: Text("Continue with Apple",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white)))
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                        width: 1, color: Colors.white)),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Get.to(Signup(
                                        title: "Create Account - Room8"));
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          top: 8.sp, bottom: 10.sp),
                                      child: RichText(
                                        softWrap: true,
                                        maxLines: 2,
                                        text: TextSpan(
                                          // Note: Styles for TextSpans must be explicitly defined.
                                          // Child text spans will inherit styles from parent
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: 'Not a member?',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 77, 77, 77),
                                                    fontSize: 14)),
                                            TextSpan(
                                                text: 'Signup ',
                                                style: const TextStyle()),
                                          ],
                                        ),
                                      ))),
                            ],
                          ),
                        ))))));
  }
}
