import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as eos;

class Auth {
  //static String userId = Hive.box('name').get('userID');
  static String baseUrl = "https://statup.ng/room8/room8/index.php/";

  Future<dynamic> signup({
    @required String? username,
    @required String? email,
    @required String? password,
    @required File? profile_pic,
  }) async {
    try {
      var dio = eos.Dio();

      var formData = eos.FormData.fromMap({
        'username': username!.trim(),
        'email': email!.trim().toLowerCase(),
        'password': password,
      });

      if (profile_pic != null) {
        List<File> mainMediaHolder = [];

        mainMediaHolder.add(profile_pic);

        int c = 0;
        for (File item in mainMediaHolder) {
          formData.files.addAll([
            MapEntry("files" + c.toString(),
                await eos.MultipartFile.fromFile(item.path)),
          ]);
          c++;
        }
      }

      var response = await dio.post(baseUrl + 'members/signup',
          data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error

          return "That email is taken already!";
        } else if (data["code"] == 1) {
          //email already exists
          return "Please use a valid email. ";
        } else if (data["code"] == 2) {
          //invalid email
          return "That email is taken already!";
        } else if (data["code"] == 200) {
          Hive.box("room8").put("loggedIn", true);
          return 200;
        } else {
          print(response.data.toString());
          return "Sorry! could not connect to server. Try again.";
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());

      return "Sorry! could not connect to server. Try again.";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "Sorry! could not connect to server. Try again.";
    };
  }

  Future<dynamic> login({
    @required String? username_or_email,
    @required String? password,
  }) async {
    try {
      var dio = eos.Dio();

      var formData = eos.FormData.fromMap({
        'username_or_email': username_or_email!.trim(),
        'password': password,
      });

      var response = await dio.post(baseUrl + 'members/login',
          data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //wrong password

          return "Wrong password";
        } else if (data["code"] == 1) {
          //login successful
          Hive.box("room8").put("loggedIn", true);
          Hive.box("room8").put("user_data", data["user_data"]);

        

          return 1;
        } else if (data["code"] == 2) {
          //Username or email incorrect
          print(response.data.toString());
          return "Username or email incorrect";
        } else {
          return "Sorry! could not connect to server. Try again.";
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());

      return "Sorry! could not connect to server. Try again.";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "Sorry! could not connect to server. Try again.";
    };
  }

  Future<dynamic> sendOTP({
    @required String? username_or_email,
  }) async {
    try {
      var dio = eos.Dio();

      var formData = eos.FormData.fromMap({
        'username_or_email': username_or_email!.trim(),
      });

      var response = await dio.post(baseUrl + 'members/send_otp',
          data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //Could not connect to server

          return "Could not connect to server";
        } else if (data["code"] == 1) {
          //otp sent successfully
          Hive.box("room8").put("recovery_email", data['recovery_email']);
          Hive.box("room8").put("loggedIn", true);

          // print(Hive.box("room8").get("recovery_email").toString());
          return 1;
        } else if (data["code"] == 2) {
          //username/email doesn't exist
          print(response.data.toString());
          return "username/email doesn't exist";
        } else {
          return "Sorry! could not connect to server. Try again.";
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());

      return "Sorry! could not connect to server. Try again.";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "Sorry! could not connect to server. Try again.";
    };
  }

  Future<dynamic> change_password(
      {@required String? otp, @required String? new_password}) async {
    try {
      var dio = eos.Dio();

      var formData = eos.FormData.fromMap({
        'email': Hive.box("room8").get("recovery_email"),
        'otp': otp,
        'new_password': new_password
      });

      var response = await dio.post(baseUrl + 'members/change_password',
          data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
            },
          ));

      print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //could not connect to change password - mysql error etc

          return "Could not change password! Please try again";
        } else if (data["code"] == 1) {
          //otp sent successfully
          Hive.box("room8").put("user_data", data["user_data"]);
          return 1;
        } else if (data["code"] == 2) {
          //password changed
          //load data into storage
          print(response.data.toString());
          return "Could not verify otp. Please try again";
        } else {
          return "Sorry! could not connect to server. Try again.";
        }
      }
    } catch (e) {
      print("Error/Exception caught " + e.toString());

      return "Sorry! could not connect to server. Try again.";
    }
    throw (e) {
      print("Error/Exception thrown " + e.toString());
      return "Sorry! could not connect to server. Try again.";
    };
  }
}
