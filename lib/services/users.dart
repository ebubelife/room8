import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as eos;

class Users {
  //static String userId = Hive.box('name').get('userID');
  static String baseUrl = "https://statup.ng/room8/room8/index.php/";

  var user_data = Hive.box("room8").get("user_data");

  Future<dynamic> followUser({String? id_to_follow}) async {
    try {
      var dio = eos.Dio();

      var formData = eos.FormData.fromMap({
        'id_to_follow': id_to_follow!.trim(),
        'id_of_follower': user_data["id"],
      });

      var response = await dio.post(baseUrl + 'members/follow_user',
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

          return "An error occured";
        } else if (data["code"] == 1) {
          //user was followed

          return 1;
        } else if (data["code"] == 2) {
          //user was unfollowed
          return 2;
        } else {
          //an error occured... possibly server error
          print(response.data.toString());
          return 0;
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
}
