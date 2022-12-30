import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart' as eos;

class Others {
  //static String userId = Hive.box('name').get('userID');
  static String baseUrl = "https://statup.ng/room8/room8/index.php/";
  var user_data = Hive.box("room8").get("user_data");

  Future<dynamic> get_notifs() async {
    String? access_token = user_data["access_token"];
    print("access_token" + access_token.toString());

    try {
      //eos.Response response;
      var dio = eos.Dio();

      var response = await dio.get(baseUrl + 'members/get_notifs',
          // data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
              // "Content-Type": "multipart/form-data",
              "Authorization": access_token.toString()
            },
          ));

      //print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error
          print(data["message"]);

          return [];
        } else if (data["code"] == 1) {
          print("notifications retrieved");
          Hive.box("room8").put("all_notifs", data["data"]);
          return data["data"];
        } else {
          Hive.box("room8").put("all_notifs", []);
          return [];
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return "failed";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "failed";
    };
  }

  Future<dynamic> update_notif({@required String? notif_id}) async {
    try {
      var dio = eos.Dio();

      var response =
          await dio.get(baseUrl + 'members/update_notif?notif_id=${notif_id!}',
              //  data: formData,
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

          return "Operation failed";
        } else if (data["code"] == 1) {
          //successfully done

          return 1;
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

  //search for users

  Future<dynamic> search_for_user ({@required String? search_term}) async {
    String? access_token = user_data["access_token"];
    print("access_token" + access_token.toString());

    try {
      //eos.Response response;
      var dio = eos.Dio();

      var response = await dio.get(baseUrl + 'members/search_members?search_term=$search_term',
          // data: formData,
          options: eos.Options(
            headers: {
              "accept": "application/json",
              // "Content-Type": "multipart/form-data",
              "Authorization": access_token.toString()
            },
          ));

      //print(response.data.toString());
      var data = jsonDecode(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["code"] == 0) {
          //network or server error
          print(data["message"]);

          return [];
        } else if (data["code"] == 1) {
          print("search retrived");
           
          return data["data"];
        } else {
          return [];
        }
      }
    } catch (e) {
      print("Error/Exception caught" + e.toString());
      return "failed";
    }
    throw (e) {
      print("Error/Exception thrown" + e.toString());
      return "failed";
    };
  }

}
