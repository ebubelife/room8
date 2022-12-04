import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:roomnew/components/form_fields.dart';
import 'package:roomnew/components/loading.dart';
import 'package:roomnew/components/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roomnew/screens/login.dart';
import 'package:roomnew/services/auth.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  const Signup({super.key, required this.title});

  final String title;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool termsCheckBox = true;
  bool _visible = true;

  //text controllers
  TextEditingController email_controller = TextEditingController();
  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController confirm_password_controller = TextEditingController();

  bool obscure_password = true, obscure_repeat_password = true;
  bool profile_pic_selected = true;
  List<File> selected_image = [];

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
                              SizedBox(
                                child: Image.asset("assets/images/logo.PNG",
                                    width: 80, height: 40.sp),
                              ),
                              Transform.rotate(
                                angle: 45 * math.pi / 180,
                                child: Container(
                                    width: 70,
                                    height: 70.sp,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        gradient: new LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 73, 10, 0),
                                              const Color(0xFF841706),
                                            ],
                                            begin: const FractionalOffset(
                                                0.0, -0.5),
                                            end: const FractionalOffset(
                                                1.0, 0.6),
                                            stops: [0.6, 1.0],
                                            tileMode: TileMode.clamp),
                                        borderRadius: BorderRadius.all(
                                            (Radius.circular(22)))),
                                    child: selected_image.isNotEmpty
                                        ? Stack(
                                            children: [
                                              //display selected image
                                              GestureDetector(
                                                  onTap: () async {
                                                    ImagePicker picker =
                                                        ImagePicker();
                                                    XFile? file =
                                                        await picker.pickImage(
                                                            source: ImageSource
                                                                .gallery,
                                                                
                                                            imageQuality: 50);
                                                    if (file != null) {
                                                      setState(() {
                                                        selected_image.clear();
                                                        selected_image.add(
                                                            File(file.path));
                                                      });
                                                    }
                                                  },
                                                  child: Transform.rotate(
                                                    angle: 310 * math.pi / 180,
                                                    child: ClipOval(
                                                        child: Image.file(
                                                      selected_image[0],
                                                      width: 60,
                                                      height: 60,
                                                    )),
                                                  ))
                                            ],
                                            //else display default select icon
                                          )
                                        : Stack(
                                            children: [
                                              GestureDetector(
                                                  onTap: () async {
                                                    ImagePicker picker =
                                                        ImagePicker();
                                                    XFile? file =
                                                        await picker.pickImage(
                                                            source: ImageSource
                                                                .gallery,
                                                            imageQuality: 50);
                                                    if (file != null) {
                                                      setState(() {
                                                        selected_image.clear();
                                                        selected_image.add(
                                                            File(file.path));
                                                      });
                                                    }
                                                  },
                                                  child: Transform.rotate(
                                                      angle: 45 * math.pi / 180,
                                                      child: Container(
                                                          width:
                                                              double.maxFinite,
                                                          height:
                                                              double.maxFinite,
                                                          child:
                                                              Transform.rotate(
                                                                  angle: -90 *
                                                                      math.pi /
                                                                      180,
                                                                  child: Center(
                                                                      child:
                                                                          Icon(
                                                                    Icons
                                                                        .camera_alt,
                                                                    color: Color(
                                                                        0xff373737),
                                                                  ))),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius: BorderRadius
                                                                  .all((Radius
                                                                      .circular(
                                                                          16)))))))
                                            ],
                                          )),
                              ),
                              CustomField(
                                  hint: "Username",
                                  controller: username_controller,
                                  maxL: 15),
                              CustomField(
                                hint: "Email Address",
                                controller: email_controller,
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
                              CustomField(
                                hint: "Re-Enter Password",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() => obscure_repeat_password =
                                        !obscure_repeat_password);
                                  },
                                  icon: Icon(
                                      obscure_repeat_password
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                      size: 20),
                                ),
                                controller: confirm_password_controller,
                                obscureText: obscure_repeat_password,
                              ),
                              Container(
                                width: double.maxFinite,
                                margin: EdgeInsets.only(top: 5),
                                child: Row(children: [
                                  Checkbox(
                                      value: termsCheckBox,
                                      fillColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      checkColor: Colors.black,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          termsCheckBox = !termsCheckBox;
                                        });
                                      }),
                                  Expanded(
                                      child: RichText(
                                    softWrap: true,
                                    maxLines: 2,
                                    text: TextSpan(
                                      // Note: Styles for TextSpans must be explicitly defined.
                                      // Child text spans will inherit styles from parent
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text:
                                                'By continuing, you agree to our '),
                                        TextSpan(
                                            text: 'Terms of Service ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        TextSpan(text: 'and '),
                                        TextSpan(
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            text: 'Privacy Policy '),
                                      ],
                                    ),
                                  )),
                                ]),
                              ),
                              SizedBox(
                                height: 7.sp,
                              ),
                              GestureDetector(
                                  onTap: (() {
                                    if (username_controller.text.isNotEmpty &&
                                        email_controller.text.isNotEmpty &&
                                        password_controller.text.isNotEmpty) {
                                      if (selected_image.isNotEmpty) {
                                        loading2("Loading", context);
                                        Auth()
                                            .signup(
                                                username:
                                                    username_controller.text,
                                                email: email_controller.text,
                                                profile_pic:
                                                    selected_image.first,
                                                password:
                                                    password_controller.text)
                                            .then((value) => {
                                                  if (value == 200)
                                                    {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                      showToast(
                                                          "Your account was created successfully"),
                                                      Get.to(Login(
                                                          title:
                                                              "Room8 - Login"))
                                                    }
                                                  else
                                                    {
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop(),
                                                      showToast(value)
                                                    }
                                                });
                                      } else {
                                        showToast(
                                            "Please add a profile image!");
                                      }
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
                                            child: Text("Sign Up",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                          //rest of the existing code
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
                                    Get.to(
                                        Login(title: "Welcome Back - Room8"));
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
                                                text: 'Joined us before? ',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 77, 77, 77),
                                                    fontSize: 14)),
                                            TextSpan(
                                                text: 'Login ',
                                                style: const TextStyle()),
                                          ],
                                        ),
                                      ))),
                            ],
                          ),
                        ))))));
  }
}
